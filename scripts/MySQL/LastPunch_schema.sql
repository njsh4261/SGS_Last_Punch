CREATE TABLE `account`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `displayName` VARCHAR(255) NULL,
    `description` TEXT NULL,
    `phone` VARCHAR(255) NULL,
    `country` CHAR(255) NOT NULL,
    `language` CHAR(255) NOT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `level` TINYINT NOT NULL,
    `point` BIGINT NOT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL
);

CREATE TABLE `workspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL
);

CREATE TABLE `channel`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `workspaceId` BIGINT UNSIGNED NOT NULL,
    `creatorId` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `topic` VARCHAR(255) NULL,
    `description` TEXT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL,
    INDEX (`workspaceId`),
    INDEX (`creatorId`)
);
ALTER TABLE `channel` ADD CONSTRAINT `channel_workspaceid_foreign` FOREIGN KEY(`workspaceId`) REFERENCES `workspace`(`id`);
ALTER TABLE `channel` ADD CONSTRAINT `channel_creatorid_foreign` FOREIGN KEY(`creatorId`) REFERENCES `account`(`id`);

CREATE TABLE `presence`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `accountId` BIGINT UNSIGNED NOT NULL,
    `mac` VARCHAR(255) NOT NULL,
    `loginDt` DATETIME NOT NULL,
    `logoutDt` DATETIME NULL,
    INDEX (`accountId`)
);
ALTER TABLE `presence` ADD CONSTRAINT `presence_accountid_foreign` FOREIGN KEY(`accountId`) REFERENCES `account`(`id`);

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
    INDEX (`channelId`)
);
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_accountid_foreign` FOREIGN KEY(`accountId`) REFERENCES `account`(`id`);
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_channelid_foreign` FOREIGN KEY(`channelId`) REFERENCES `channel`(`id`);
ALTER TABLE `accountchannel` ADD CONSTRAINT `accountchannel_roleid_foreign` FOREIGN KEY(`roleId`) REFERENCES `role`(`id`);

CREATE TABLE `accountworkspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `accountId` BIGINT UNSIGNED NOT NULL,
    `workspaceId` BIGINT UNSIGNED NOT NULL,
    INDEX (`accountId`),
    INDEX (`workspaceId`)
);
ALTER TABLE `accountworkspace` ADD CONSTRAINT `accountworkspace_workspaceid_foreign` FOREIGN KEY(`workspaceId`) REFERENCES `workspace`(`id`);
ALTER TABLE `accountworkspace` ADD CONSTRAINT `accountworkspace_accountid_foreign` FOREIGN KEY(`accountId`) REFERENCES `account`(`id`);

CREATE TABLE `file`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `description` BIGINT NULL,
    `ownerId` BIGINT UNSIGNED NOT NULL,
    `thumbnail` BINARY(16) NULL,
    `location` VARCHAR(255) NOT NULL,
    `status` TINYINT NOT NULL,
    `createDt` DATETIME NOT NULL,
    `modifyDt` DATETIME NOT NULL
);
ALTER TABLE `file` ADD CONSTRAINT `file_ownerid_foreign` FOREIGN KEY(`ownerId`) REFERENCES `account`(`id`);
