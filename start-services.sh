#!/bin/bash

echo "Starting Online Taxi Microservices..."
echo "======================================"

# Function to start a service in the background
start_service() {
    SERVICE_DIR=$1
    SERVICE_NAME=$2
    PORT=$3
    
    echo "Starting $SERVICE_NAME on port $PORT..."
    cd $SERVICE_DIR
    mvn spring-boot:run -DskipTests > ../logs/${SERVICE_NAME}.log 2>&1 &
    echo "  -> $SERVICE_NAME PID: $!"
    cd ..
}

# Create logs directory
mkdir -p logs

echo ""
echo "1. Starting Eureka Service Registry (Port 7900)..."
cd eureka
mvn spring-boot:run -DskipTests -Dspring.profiles.active=7900 > ../logs/eureka.log 2>&1 &
EUREKA_PID=$!
echo "  -> Eureka PID: $EUREKA_PID"
cd ..

echo ""
echo "Waiting for Eureka to start..."
sleep 30

echo ""
echo "2. Starting Core Services..."

# Start verification code service (Port 8001)
start_service "service-verification-code" "Verification Code Service" "8001"
sleep 5

# Start passenger user service (Port 8002) 
start_service "service-passenger-user" "Passenger User Service" "8002"
sleep 5

# Start order service (Port 8004)
start_service "service-order" "Order Service" "8004"
sleep 5

echo ""
echo "3. Starting API Layer..."

# Start passenger API (Port 9001)
start_service "api-passenger" "Passenger API" "9001"
sleep 5

echo ""
echo "4. Starting Gateway (Port 9000)..."
start_service "online-taxi-gateway" "API Gateway" "9000"

echo ""
echo "======================================"
echo "All services started successfully!"
echo ""
echo "Service URLs:"
echo "  - Eureka Dashboard: http://localhost:7900 (root/root)"
echo "  - Passenger API: http://localhost:9001"
echo "  - API Gateway: http://localhost:9000"
echo ""
echo "To check service status:"
echo "  ps aux | grep java"
echo ""
echo "To view logs:"
echo "  tail -f logs/[service-name].log"
echo ""
echo "To stop all services:"
echo "  pkill -f 'spring-boot:run'"