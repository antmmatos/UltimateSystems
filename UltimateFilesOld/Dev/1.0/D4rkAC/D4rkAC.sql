CREATE TABLE `D4rkAC` (
    `ID` INT NOT NULL AUTO_INCREMENT,
    `PlayerName` VARCHAR(50) NOT NULL,
    `SteamID` VARCHAR(50) NOT NULL,
    `License` VARCHAR(50) NOT NULL,
    `DiscordID` VARCHAR(40) NOT NULL,
    `PlayerIP` VARCHAR(20) NOT NULL,
    `Date` VARCHAR(20) NOT NULL,
    `Reason` VARCHAR(100) NOT NULL,
    `Admin` VARCHAR(100) NOT NULL,
    `Screenshot` VARCHAR(50) NULL,
	PRIMARY KEY (`ID`)
)