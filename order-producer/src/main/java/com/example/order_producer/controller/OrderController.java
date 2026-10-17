package com.example.order_producer.controller;

import com.example.order_producer.dto.CreateOrderRequest;
import com.example.order_producer.service.SqsProducerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import tools.jackson.databind.ObjectMapper;

import java.util.Map;

@RestController
@RequestMapping("/orders")
public class OrderController {

    private final SqsProducerService sqsProducerService;
    private final ObjectMapper objectMapper;

    public OrderController(
            SqsProducerService sqsProducerService,
            ObjectMapper objectMapper) {
        this.sqsProducerService = sqsProducerService;
        this.objectMapper = objectMapper;
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> createOrder(
            @RequestBody CreateOrderRequest request) {

        String messageBody =
                objectMapper.writeValueAsString(request);

        String messageId =
                sqsProducerService.sendMessage(messageBody);

        return ResponseEntity
                .status(HttpStatus.ACCEPTED)
                .body(Map.of(
                        "message", "Order accepted for processing",
                        "orderId", request.orderId(),
                        "messageId", messageId
                ));
    }
}