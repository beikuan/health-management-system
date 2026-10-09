package com.example.demo.service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Date;

@Service
public class JwtService {

    private final Algorithm algorithm;
    private final long expirationMs;

    public JwtService(@Value("${app.jwt.secret}") String secret,
                      @Value("${app.jwt.expiration-ms}") long expirationMs) {
        if (secret == null || secret.length() < 32) {
            throw new IllegalStateException("JWT_SECRET must contain at least 32 characters");
        }
        this.algorithm = Algorithm.HMAC256(secret);
        this.expirationMs = expirationMs;
    }

    public String createToken(String userId) {
        Instant now = Instant.now();
        return JWT.create()
                .withSubject(userId)
                .withIssuedAt(Date.from(now))
                .withExpiresAt(Date.from(now.plusMillis(expirationMs)))
                .sign(algorithm);
    }

    public String verifyAndGetUserId(String token) {
        DecodedJWT jwt = JWT.require(algorithm).build().verify(token);
        String userId = jwt.getSubject();
        if (userId == null || userId.isBlank()) {
            throw new IllegalArgumentException("Token does not contain a user id");
        }
        return userId;
    }

    public long getExpirationMs() {
        return expirationMs;
    }
}
