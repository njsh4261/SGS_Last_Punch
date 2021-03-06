CREATE TABLE `account`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `phone` VARCHAR(255) NULL,
    `country` CHAR(255) NOT NULL,
    `status` TINYINT NULL,
    `imageNum` TINYINT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL
);

CREATE TABLE `workspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `imageNum` TINYINT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL
);

CREATE TABLE `channel`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `workspaceId` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `topic` VARCHAR(255) NULL,
    `description` TEXT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL,
    INDEX (`workspaceId`),
    UNIQUE (`workspaceId`, `name`)
);
ALTER TABLE `channel` ADD CONSTRAINT `channel_workspaceid_foreign` FOREIGN KEY(`workspaceId`) REFERENCES `workspace`(`id`) ON DELETE CASCADE;

CREATE TABLE `role`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `accountchannel`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `accountId` BIGINT UNSIGNED NOT NULL,
    `channelId` BIGINT UNSIGNED NOT NULL,
    `roleId` BIGINT UNSIGNED NOT NULL,
    INDEX (`accountId`),
    INDEX (`channelId`),
    UNIQUE (`accountId`, `channelId`)
);
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_accountid_foreign` FOREIGN KEY(`accountId`) REFERENCES `account`(`id`) ON DELETE CASCADE;
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_channelid_foreign` FOREIGN KEY(`channelId`) REFERENCES `channel`(`id`) ON DELETE CASCADE;
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_roleid_foreign` FOREIGN KEY(`roleId`) REFERENCES `role`(`id`) ON DELETE CASCADE;

CREATE TABLE `accountworkspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `accountId` BIGINT UNSIGNED NOT NULL,
    `workspaceId` BIGINT UNSIGNED NOT NULL,
    `roleId` BIGINT UNSIGNED NOT NULL,
    INDEX (`accountId`),
    INDEX (`workspaceId`),
    UNIQUE (`accountId`, `workspaceId`)
);
ALTER TABLE `accountworkspace` ADD CONSTRAINT `accountworkspace_workspaceid_foreign` FOREIGN KEY(`workspaceId`) REFERENCES `workspace`(`id`) ON DELETE CASCADE;
ALTER TABLE `accountworkspace` ADD CONSTRAINT `accountworkspace_accountid_foreign` FOREIGN KEY(`accountId`) REFERENCES `account`(`id`) ON DELETE CASCADE;
ALTER TABLE `accountworkspace` ADD CONSTRAINT `accountworkspace_roleid_foreign` FOREIGN KEY(`roleId`) REFERENCES `role`(`id`) ON DELETE CASCADE;
