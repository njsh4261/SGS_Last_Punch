CREATE TABLE `workspace`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `language` CHAR(255) NOT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL
);

CREATE TABLE `member`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `login_type` TINYINT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `display_name` VARCHAR(255) NULL,
    `role_desc` TEXT NULL,
    `phone_number` VARCHAR(255) NULL,
    `country_code` CHAR(2) NOT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `membership_level` TINYINT NOT NULL,
    `membership_point` BIGINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL,
    `last_login_dt` DATETIME NOT NULL
);

CREATE TABLE `member_workspace`(
    `member_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
	INDEX (`workspace_id`)
);

CREATE TABLE `channel`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `workspace_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `topic` VARCHAR(255) NULL,
    `description` TEXT NULL,
    `creator` VARCHAR(255) NOT NULL,
    `settings` TINYINT NOT NULL,
    `status` TINYINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL,
	INDEX (`workspace_id`)
);

CREATE TABLE `reply`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `message_id` BIGINT UNSIGNED NOT NULL,
    `content` TEXT NOT NULL,
    `status` TINYINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL,
	INDEX (`message_id`)
);

CREATE TABLE `notification`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `target_id` BIGINT UNSIGNED NOT NULL,
    `target_type` TINYINT NOT NULL,
    `content` TEXT NOT NULL,
    `status` TINYINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL
);

CREATE TABLE `member_notification`(
    `member_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `notification_id` BIGINT UNSIGNED NOT NULL,
	INDEX (`notification_id`)
);

CREATE TABLE `message`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `channel_id` BIGINT UNSIGNED NOT NULL,
    `content` TEXT NOT NULL,
    `refer_reply_id` BIGINT UNSIGNED NULL,
    `status` TINYINT NOT NULL,
    `created_dt` DATETIME NOT NULL,
    `modified_dt` DATETIME NOT NULL,
    `reply_count` INT NOT NULL,
    `last_reply_dt` DATETIME NOT NULL,
	INDEX (`channel_id`)
);

CREATE TABLE `channel_member`(
    `channel_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `member_id` BIGINT UNSIGNED NOT NULL, 
	INDEX (`member_id`)
);

CREATE TABLE `message_user`(
    `message_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `member_id` BIGINT UNSIGNED NOT NULL,
	INDEX (`member_id`)
);

ALTER TABLE `channel` ADD CONSTRAINT `channel_workspace_id_foreign` FOREIGN KEY(`workspace_id`) REFERENCES `workspace`(`id`);
ALTER TABLE `member_workspace` ADD CONSTRAINT `member_workspace_workspace_id_foreign` FOREIGN KEY(`workspace_id`) REFERENCES `workspace`(`id`);
ALTER TABLE `channel_member` ADD CONSTRAINT `channel_member_member_id_foreign` FOREIGN KEY(`member_id`) REFERENCES `member`(`id`);
ALTER TABLE `message_user` ADD CONSTRAINT `message_user_member_id_foreign` FOREIGN KEY(`member_id`) REFERENCES `member`(`id`);
ALTER TABLE `message` ADD CONSTRAINT `message_channel_id_foreign` FOREIGN KEY(`channel_id`) REFERENCES `channel`(`id`);
ALTER TABLE `reply` ADD CONSTRAINT `reply_message_id_foreign` FOREIGN KEY(`message_id`) REFERENCES `message`(`id`);
ALTER TABLE `member_notification` ADD CONSTRAINT `member_notification_notification_id_foreign` FOREIGN KEY(`notification_id`) REFERENCES `notification`(`id`);
ALTER TABLE `message` ADD CONSTRAINT `message_refer_reply_id_foreign` FOREIGN KEY(`refer_reply_id`) REFERENCES `reply`(`id`);
