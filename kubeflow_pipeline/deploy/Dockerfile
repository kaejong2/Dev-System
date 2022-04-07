FROM pytorch/torchserve:0.3.0-cpu

COPY . /app
WORKDIR /app
RUN pip install -U numpy faiss-cpu==1.6.1 ujson
ENTRYPOINT ["python"]
CMD ["run.py"]
   
