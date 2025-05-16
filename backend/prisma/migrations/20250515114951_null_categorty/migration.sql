/*
  Warnings:

  - You are about to alter the column `due_date` on the `lists` table. The data in that column could be lost. The data in that column will be cast from `DateTime(0)` to `DateTime`.

*/
-- AlterTable
ALTER TABLE `lists` MODIFY `due_date` DATETIME NOT NULL,
    MODIFY `category` VARCHAR(255) NULL;
