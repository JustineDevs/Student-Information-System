package com.sis.util;

import org.apache.commons.dbcp2.BasicDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseUtil {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseUtil.class);
    private static BasicDataSource dataSource;
    private static final Properties properties = new Properties();

    static {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream("database.properties")) {
            if (input == null) {
                throw new RuntimeException("Unable to find database.properties");
            }
            properties.load(input);
            initializeDataSource();
        } catch (IOException e) {
            logger.error("Error loading database properties", e);
            throw new RuntimeException("Error loading database properties", e);
        }
    }

    private static void initializeDataSource() {
        dataSource = new BasicDataSource();
        dataSource.setDriverClassName(properties.getProperty("db.driver"));
        dataSource.setUrl(properties.getProperty("db.url"));
        dataSource.setUsername(properties.getProperty("db.username"));
        dataSource.setPassword(properties.getProperty("db.password"));

        // Connection pool settings
        dataSource.setInitialSize(Integer.parseInt(properties.getProperty("db.pool.initialSize")));
        dataSource.setMaxTotal(Integer.parseInt(properties.getProperty("db.pool.maxTotal")));
        dataSource.setMaxIdle(Integer.parseInt(properties.getProperty("db.pool.maxIdle")));
        dataSource.setMinIdle(Integer.parseInt(properties.getProperty("db.pool.minIdle")));
        dataSource.setMaxWaitMillis(Long.parseLong(properties.getProperty("db.pool.maxWaitMillis")));
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void closeDataSource() {
        if (dataSource != null) {
            try {
                dataSource.close();
            } catch (SQLException e) {
                logger.error("Error closing data source", e);
            }
        }
    }
} 