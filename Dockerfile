FROM python:3.9.1 

RUN pip install --upgrade pip
RUN pip install pandas sqlalchemy psycopg2-binary
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget


WORKDIR /app

COPY ingest_data.py ingest_data.py

ENTRYPOINT [ "python" , "ingest_data.py" ]