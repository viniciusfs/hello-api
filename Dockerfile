FROM 327667905059.dkr.ecr.us-east-1.amazonaws.com/docker-base-image-python-3-7:1

COPY ./app /app
WORKDIR /app
RUN pip install -r requirements.txt

ENTRYPOINT ["gunicorn"]
CMD ["-b 0.0.0.0:5000", "wsgi:application"]
