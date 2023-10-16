FROM python:3.9

ADD main.py .

RUN pip install mysql-connector-python sqlalchemy pandas psycopg2

ENTRYPOINT ["python", "./main.py"]