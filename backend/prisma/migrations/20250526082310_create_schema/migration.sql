/*
  Warnings:

  - You are about to alter the column `due_date` on the `lists` table. The data in that column could be lost. The data in that column will be cast from `DateTime(0)` to `DateTime`.
  - Added the required column `updateAt` to the `lists` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `lists` ADD COLUMN `updateAt` DATETIME(3) NOT NULL,
    MODIFY `due_date` DATETIME NOT NULL;
