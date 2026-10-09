package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

import java.util.List;
import java.util.Map;

@Service
public class AiAdviceService {
    private final String apiKey;
    private final String model;
    private final RestClient client;

    public AiAdviceService(RestClient.Builder builder,
                           @Value("${app.ai.api-key:}") String apiKey,
                           @Value("${app.ai.base-url}") String baseUrl,
                           @Value("${app.ai.model}") String model) {
        this.apiKey = apiKey == null ? "" : apiKey.trim();
        this.model = model;
        this.client = builder.baseUrl(baseUrl).build();
    }

    public boolean isEnabled() {
        return !apiKey.isBlank();
    }

    @SuppressWarnings("unchecked")
    public String ask(String systemPrompt, String userPrompt) {
        if (!isEnabled()) {
            throw new AiUnavailableException("AI 功能尚未配置，请设置 AI_API_KEY");
        }
        Map<String, Object> body = Map.of(
                "model", model,
                "temperature", 0.7,
                "messages", List.of(
                        Map.of("role", "system", "content", systemPrompt),
                        Map.of("role", "user", "content", userPrompt)
                )
        );
        try {
            Map<String, Object> response = client.post()
                    .uri("/chat/completions")
                    .contentType(MediaType.APPLICATION_JSON)
                    .header("Authorization", "Bearer " + apiKey)
                    .body(body)
                    .retrieve()
                    .body(Map.class);
            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
            Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
            return String.valueOf(message.get("content"));
        } catch (RestClientException | NullPointerException | IndexOutOfBoundsException exception) {
            throw new AiUnavailableException("AI 服务暂时不可用，请稍后重试", exception);
        }
    }

    public static class AiUnavailableException extends RuntimeException {
        public AiUnavailableException(String message) {
            super(message);
        }

        public AiUnavailableException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
