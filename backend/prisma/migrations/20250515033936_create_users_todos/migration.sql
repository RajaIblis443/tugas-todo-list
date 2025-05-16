-- CreateTable
CREATE TABLE `lists` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `priority` BOOLEAN NOT NULL DEFAULT false,
    `due_date` DATETIME NOT NULL,
    `description` LONGTEXT NOT NULL,
    `category` VARCHAR(255) NOT NULL,
    `isFinished` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
