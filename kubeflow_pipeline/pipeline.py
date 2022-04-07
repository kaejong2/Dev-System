import kfp
import kfp.components as comp
from kfp import dsl
from kfp import onprem
from kubernetes.client.models import V1EnvVar


@dsl.pipeline(
    name="MNIST using Arcface",
    description="CT pipeline"
)
def mnist_pipeline():
    ENV_MANAGE_URL = V1EnvVar(name='MANAGE_URL', value='http://210.123.42.43:8080/send')
    pvc_name = "data"
    volume_name = 'pipeline'
    volume_mount_path = '/home/jovyan'

    data_0 = dsl.ContainerOp(
        name="load & preprocess data pipeline",
        image="kaejong/mnist-pre-data:latest",
    ).set_display_name('collect & preprocess data')\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))

    data_1 = dsl.ContainerOp(
        name="validate data pipeline",
        image="kaejong/mnist-val-data:latest",
    ).set_display_name('validate data').after(data_0)\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))

    train_model = dsl.ContainerOp(
        name="train embedding model",
        image="kaejong/mnist-train-model:latest",
    ).set_display_name('train model').after(data_1)\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))\
    .apply(onprem.mount_pvc("train-model-pvc", volume_name="train-model", volume_mount_path=volume_mount_path))

    embedding = dsl.ContainerOp(
        name="embedding data using embedding model",
        image="kaejong/mnist-embedding:latest",
    ).set_display_name('embedding').after(train_model)\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))\
    .apply(onprem.mount_pvc("train-model-pvc", volume_name="train-model", volume_mount_path=volume_mount_path))

    train_faiss = dsl.ContainerOp(
        name="train faiss",
        image="kaejong/mnist-train-faiss:latest",
    ).set_display_name('train faiss').after(embedding)\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))\
    .apply(onprem.mount_pvc("train-model-pvc", volume_name="train-model", volume_mount_path=volume_mount_path))

    analysis = dsl.ContainerOp(
        name="analysis total",
        image="kaejong/mnist-analysis:latest",
        file_outputs={
            "confusion_matrix": "/confusion_matrix.csv",
            "mlpipeline-ui-metadata": "/mlpipeline-ui-metadata.json",
            "accuracy": "/accuracy.json",
            "mlpipeline_metrics": "/mlpipeline-metrics.json"
        }
    ).add_env_variable(ENV_MANAGE_URL).set_display_name('analysis').after(train_faiss)\
    .apply(onprem.mount_pvc(pvc_name, volume_name=volume_name, volume_mount_path=volume_mount_path))\
    .apply(onprem.mount_pvc("train-model-pvc", volume_name="train-model", volume_mount_path=volume_mount_path))

    baseline = 0.8
    with dsl.Condition(analysis.outputs["accuracy"] > baseline) as check_deploy:
        deploy = dsl.ContainerOp(
            name="deploy mar",
            image="kaejong/mnist-deploy:latest",
        ).add_env_variable(ENV_MANAGE_URL).set_display_name('deploy').after(analysis)\
        .apply(onprem.mount_pvc("train-model-pvc", volume_name="train-model", volume_mount_path=volume_mount_path))\
        .apply(onprem.mount_pvc("deploy-model-pvc", volume_name="deploy-model", volume_mount_path=volume_mount_path))


if __name__=="__main__":
    host = "http://210.123.42.43:8080/pipeline"
    namespace = "kubeflow-example-user-com"

    pipeline_name = "Mnist"
    pipeline_package_path = "pipeline.zip"
    version = "v0.1"

    experiment_name = "For Develop"
    run_name = "kubeflow study {}".format(version)

    client = kfp.Client(host=host, namespace=namespace)
    kfp.compiler.Compiler().compile(mnist_pipeline, pipeline_package_path)

    pipeline_id = client.get_pipeline_id(pipeline_name)
    if pipeline_id:
        client.upload_pipeline_version(
            pipeline_package_path=pipeline_package_path,
            pipeline_version_name=version,
            pipeline_name=pipeline_name
        )
    else:
        client.upload_pipeline(
            pipeline_package_path=pipeline_package_path,
            pipeline_name=pipeline_name
        )

    experiment = client.create_experiment(name=experiment_name, namespace=namespace)
    run = client.run_pipeline(experiment.id, run_name, pipeline_package_path)


