FROM golang:1.16
ADD . / /build/
WORKDIR /build
RUN CGO_ENABLED=0 GOOS=linux go build -a -o ipmi_exporter .

FROM debian:bullseye-slim
RUN sed -i 's/http/https/g' \/etc/apt/sources.list \
&& apt update && apt install -y ipmitool
WORKDIR /root/
COPY --from=0 /build/ipmi_exporter ./
ENTRYPOINT ["./ipmi_exporter"]  
