package com.example.demo.service;

import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

import static org.junit.jupiter.api.Assertions.*;

class AiAdviceServiceTest {
    @Test
    void disabledAiDoesNotMakeExternalRequest() {
        AiAdviceService service = new AiAdviceService(RestClient.builder(), "", "https://example.invalid", "test");
        assertFalse(service.isEnabled());
        assertThrows(AiAdviceService.AiUnavailableException.class,
                () -> service.ask("system", "user"));
    }
}
