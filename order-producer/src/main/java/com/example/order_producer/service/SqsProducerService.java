/**
 * This class represents the SQS Client responsible to receive the request from API Gateway
 */
package com.example.order_producer.service;

import org.springframework.stereotype.Service;

import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;
import software.amazon.awssdk.services.sqs.model.SendMessageResponse;

@Service
public class SqsProducerService {

    private final SqsClient sqsClient;
    private final SsmParameterStoreService parameterStoreService;

    public SqsProducerService(
            SqsClient sqsClient,
            SsmParameterStoreService parameterStoreService) {
        this.sqsClient = sqsClient;
        this.parameterStoreService = parameterStoreService;
    }

    public String sendMessage(String messageBody) {

        String queueUrl =
                parameterStoreService.getOrderQueueUrl();

        SendMessageRequest request = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .build();

        SendMessageResponse response =
                sqsClient.sendMessage(request);

        return response.messageId();
    }
}