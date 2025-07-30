# Online Taxi Microservices Application

This is a Chinese online taxi (ride-hailing) service built with Spring Cloud microservices architecture.

## Architecture Overview

The application consists of multiple microservices organized in layers:

### Service Registry
- **eureka** (Port 7900) - Eureka service registry for service discovery

### API Layer (External interfaces)
- **api-passenger** (Port 9001) - Passenger-facing API
- **api-driver** (Port TBD) - Driver-facing API
- **online-taxi-gateway** (Port 9000) - API Gateway for routing

### Business Services
- **service-verification-code** (Port 8001) - SMS/verification code service
- **service-passenger-user** (Port 8002) - Passenger user management
- **service-app-update** (Port 8003) - App update service
- **service-order** (Port 8004) - Order management
- **service-order-dispatch** (Port 8005) - Order dispatch service
- **service-wallet** (Port 8006) - Wallet/payment service
- **service-sms** (Port 8007) - SMS notification service

### Infrastructure
- **online-taxi-common** - Shared common components and utilities
- **online-taxi-config-server** - Configuration server
- **hystrix-dashboard** - Circuit breaker monitoring

## Technology Stack

- **Java**: Originally Java 8, updated to Java 21
- **Spring Boot**: 2.1.7.RELEASE
- **Spring Cloud**: Greenwich.SR2
- **Maven**: Build tool
- **Eureka**: Service discovery
- **Hystrix**: Circuit breaker
- **Feign**: Declarative REST client
- **Zuul**: API Gateway (older version)

## How to Run

### Prerequisites
- Java 21 installed
- Maven 3.6+ installed

### Step 1: Build Common Components
```bash
cd online-taxi-common
mvn clean install -DskipTests
```

### Step 2: Start Eureka Service Registry
```bash
cd eureka
mvn spring-boot:run -Dspring.profiles.active=7900
```

Access Eureka Dashboard at: http://localhost:7900 (username: root, password: root)

### Step 3: Start Core Services
In separate terminals:

```bash
# Verification Code Service (Port 8001)
cd service-verification-code
mvn spring-boot:run

# Passenger User Service (Port 8002)
cd service-passenger-user  
mvn spring-boot:run

# Order Service (Port 8004)
cd service-order
mvn spring-boot:run
```

### Step 4: Start API Layer
```bash
# Passenger API (Port 9001)
cd api-passenger
mvn spring-boot:run

# API Gateway (Port 9000)
cd online-taxi-gateway
mvn spring-boot:run
```

### Step 5: Verify Services
Check Eureka dashboard to see registered services: http://localhost:7900

## Service Endpoints

Once running, the main endpoints would be:
- **Eureka Dashboard**: http://localhost:7900
- **Passenger API**: http://localhost:9001
- **API Gateway**: http://localhost:9000
- **Individual Services**: Available through the gateway or directly

## Configuration Notes

- Services use `bootstrap.yml` for configuration
- Eureka authentication: root/root
- Most services are configured to register with Eureka at `eureka-7900:7900`
- Configuration can be externalized through the config server

## Troubleshooting

### Java Version Compatibility
The original project was built for Java 8 with Spring Boot 2.1.7. When upgrading to Java 21:
1. Update `java.version` in all pom.xml files
2. Update Lombok to version 1.18.30+
3. May need to update Spring Boot/Cloud versions for full compatibility

### Service Dependencies
Services must start in order:
1. Eureka (service registry)
2. Config Server (if used)
3. Business services
4. API layer
5. Gateway

### Common Issues
- Ensure Eureka is running before starting other services
- Check port conflicts
- Verify database connections (if configured)
- Check service discovery registration in Eureka dashboard

## Development

This is a learning/demo project showing microservices patterns:
- Service discovery with Eureka
- Circuit breakers with Hystrix  
- Load balancing with Ribbon
- API gateway with Zuul
- Declarative REST clients with Feign
- Distributed configuration

## Project Structure

```
online-taxi/
├── eureka/                     # Service registry
├── online-taxi-common/         # Shared utilities
├── online-taxi-gateway/        # API gateway
├── api-passenger/              # Passenger API
├── service-*/                  # Business services
├── config-*/                   # Configuration services
└── study-*/                    # Study/demo modules
```