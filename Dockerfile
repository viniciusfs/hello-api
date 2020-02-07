FROM python:2.7

COPY ./app /app
WORKDIR /app
RUN pip install -r requirements.txt

EXPOSE 8000

ENTRYPOINT ["gunicorn"]
CMD ["-b 0.0.0.0", "wsgi:application"]
