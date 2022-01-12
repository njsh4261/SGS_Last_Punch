CREATE TABLE `user`(
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
ALTER TABLE `channel` ADD CONSTRAINT `channel_creatorid_foreign` FOREIGN KEY(`creatorId`) REFERENCES `user`(`id`);

CREATE TABLE `presence`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `userId` BIGINT UNSIGNED NOT NULL,
    `mac` VARCHAR(255) NOT NULL,
    `loginDt` DATETIME NOT NULL,
    `logoutDt` DATETIME NULL,
    INDEX (`userId`)
);
ALTER TABLE `presence` ADD CONSTRAINT `presence_userid_foreign` FOREIGN KEY(`userId`) REFERENCES `user`(`id`);

CREATE TABLE `role`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `user_channel`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `userId` BIGINT UNSIGNED NOT NULL,
    `channelId` BIGINT UNSIGNED NOT NULL,
    `roleId` BIGINT UNSIGNED NOT NULL,
    INDEX (`userId`),
    INDEX (`channelId`)
);
ALTER TABLE `user_channel` ADD CONSTRAINT `user_channel_userid_foreign` FOREIGN KEY(`userId`) REFERENCES `user`(`id`);
ALTER TABLE `user_channel` ADD CONSTRAINT `user_channel_channelid_foreign` FOREIGN KEY(`channelId`) REFERENCES `channel`(`id`);
ALTER TABLE `user_channel` ADD CONSTRAINT `user_channel_roleid_foreign` FOREIGN KEY(`roleId`) REFERENCES `role`(`id`);

CREATE TABLE `user_workspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `userId` BIGINT UNSIGNED NOT NULL,
    `workspaceId` BIGINT UNSIGNED NOT NULL,
    INDEX (`userId`),
    INDEX (`workspaceId`)
);
ALTER TABLE `user_workspace` ADD CONSTRAINT `user_workspace_workspaceid_foreign` FOREIGN KEY(`workspaceId`) REFERENCES `workspace`(`id`);
ALTER TABLE `user_workspace` ADD CONSTRAINT `user_workspace_userid_foreign` FOREIGN KEY(`userId`) REFERENCES `user`(`id`);

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
ALTER TABLE `file` ADD CONSTRAINT `file_ownerid_foreign` FOREIGN KEY(`ownerId`) REFERENCES `user`(`id`);
