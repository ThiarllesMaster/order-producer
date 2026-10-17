package com.example.order_producer.dto;

import java.math.BigDecimal;

public record CreateOrderRequest(
        String orderId,
        String customerId,
        String product,
        Integer quantity,
        BigDecimal total
) {
}