import os
import splitfolders
import glob
def image_resize(data_path):
    glob.glob(data_path+"/*",recursive=True)
def data_split(data_path):
    data = ['train', 'val', 'test']
    label = os.listdir(data_path)
    splitfolders.ratio(f'{data_path}', output=f'{data_path}/dataset', seed=42, ratio=(0.7, 0.15, 0.15))
    # print data amount
    for i in data:
        for j in label:
            count = len(os.listdir(f'{data_path}/dataset/{i}/{j}'))
            print(f'Crack | {i} | {j} : {count}')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument('--data_path', type=str, default='/mnt/hdd_10tb_sda/animals')

    parser.add_argument('--image_width', type=int, default=224)
    parser.add_argument('--image_height', type=int, default=224)
    parser.add_argument('--image_channel', type=int, default=3)
    parser.add_argument('--npy_interval', type=int, default=500)

    args = parser.parse_args()

    print("Image Resize...")
    image_resize(data_path=opt.data_path)
    print("Data Split...")
    data_split(data_path=opt.data_path)
    print("Validating data...")
    validation_data(
        train_data_file=os.path.join(args.train_data_path, args.train_data_file),
        test_data_file=os.path.join(args.test_data_path, args.test_data_file),
        faiss_train_data_file=os.path.join(args.faiss_train_data_path, args.faiss_train_data_file),
        faiss_test_data_file=os.path.join(args.faiss_test_data_path, args.faiss_test_data_file),
        image_width=args.image_width,
        image_height=args.image_height,
        image_channel=args.image_channel,
        image_type=np.float32,
        label_type=np.int64
    )
