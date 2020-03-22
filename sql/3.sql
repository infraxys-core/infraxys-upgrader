ALTER TABLE `infraxys`.`instances`
    ADD CONSTRAINT `FK_INSTANCES_PACKETS`
        FOREIGN KEY (`PACKET_ID`)
            REFERENCES `infraxys`.`packets` (`id`)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;

