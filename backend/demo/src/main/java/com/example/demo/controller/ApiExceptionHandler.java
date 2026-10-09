package com.example.demo.controller;

import com.example.demo.domain.R;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import com.example.demo.service.AiAdviceService.AiUnavailableException;

@RestControllerAdvice
public class ApiExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<R<Void>> validation(MethodArgumentNotValidException exception) {
        String message = exception.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(error -> error.getDefaultMessage())
                .orElse("请求参数不正确");
        return ResponseEntity.badRequest().body(R.to(message, 400));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<R<Void>> illegalArgument(IllegalArgumentException exception) {
        return ResponseEntity.badRequest().body(R.to(exception.getMessage(), 400));
    }

    @ExceptionHandler(DuplicateKeyException.class)
    public ResponseEntity<R<Void>> duplicate(DuplicateKeyException exception) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(R.to("数据已经存在", 409));
    }

    @ExceptionHandler(AiUnavailableException.class)
    public ResponseEntity<R<Void>> aiUnavailable(AiUnavailableException exception) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(R.to(exception.getMessage(), 503));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<R<Void>> unexpected(Exception exception) {
        return ResponseEntity.internalServerError().body(R.to("服务器内部错误", 500));
    }
}
