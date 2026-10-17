/**
 * This class is responsible to communicate with the Parameter Store and set the URL to ParameterStore Client
 */

package com.example.order_producer.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.services.ssm.SsmClient;
import software.amazon.awssdk.services.ssm.model.GetParameterRequest;
import software.amazon.awssdk.services.ssm.model.GetParameterResponse;

@Service
public class SsmParameterStoreService {

    private SsmClient ssmClient;

    @Value("${aws.parameter-store.order-queue-url}")
    private String parameterName;

    public SsmParameterStoreService(SsmClient ssmClient) {
        this.ssmClient = ssmClient;

    }

    public String getOrderQueueUrl() {
        GetParameterRequest request = GetParameterRequest.builder()
                .name(parameterName)
                .build();

        GetParameterResponse response =
                ssmClient.getParameter(request);

        return response.parameter().value();
    }
}
