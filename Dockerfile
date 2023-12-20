FROM python:3.8
WORKDIR /app
COPY . /app
RUN pip install Flask Flask-SQLAlchemy psycopg2-binary
EXPOSE 5000
CMD ["python", "app.py"]

