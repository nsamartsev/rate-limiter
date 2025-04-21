# rate-limiter

Rate limiter in Go


## How to build

1. Go to root of project's directory

2. Launch the command to build image
```bash
docker build -t rate-limiter .
```

3. Run the container from image with port-forwarding
```bash
docker run -itd -p 8080:8080 rate-limiter
```

4. Go to browser [http://localhost:8080](http://localhost:8080)