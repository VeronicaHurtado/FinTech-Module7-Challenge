/* Drop existing tables if any, to avoid duplicates/errors */
DROP TABLE if exists transaction;
DROP TABLE if exists merchant;
DROP TABLE if exists merchant_category;
DROP TABLE if exists credit_card;
DROP TABLE if exists card_holder;

/* Create all tables */
CREATE TABLE "card_holder"
(
    "id" INT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    CONSTRAINT "pk_card_holder" PRIMARY KEY ("id")
);

CREATE TABLE "credit_card"
(
    "card" VARCHAR(20) NOT NULL,
    "cardholder_id" INT NOT NULL,
    CONSTRAINT "pk_card" PRIMARY KEY ("card")
);

CREATE TABLE "merchant"
(
    "id" INT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "merchant_category_id" INT NOT NULL,
    CONSTRAINT "pk_merchant" PRIMARY KEY ("id")
);

CREATE TABLE "merchant_category"
(
    "id" INT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    CONSTRAINT "pk_merchant_category" PRIMARY KEY ("id")
);

CREATE TABLE "transaction"
(
    "id" INT NOT NULL,
    "date" TIMESTAMP NOT NULL,
    "amount" FLOAT NOT NULL,
    "card" VARCHAR(20) NOT NULL,
    "merchant_id" INT NOT NULL,
    CONSTRAINT "pk_transaction" PRIMARY KEY ("id")
);

ALTER TABLE "credit_card"
    ADD CONSTRAINT "fk_credit_card_cardholder_id" FOREIGN KEY ("cardholder_id")
        REFERENCES "card_holder" ("id");

ALTER TABLE "merchant"
    ADD CONSTRAINT "fk_merchant_merchant_category_id" FOREIGN KEY ("merchant_category_id")
        REFERENCES "merchant_category" ("id");

ALTER TABLE "transaction"
    ADD CONSTRAINT "fk_transaction_card" FOREIGN KEY ("card")
        REFERENCES "credit_card" ("card");

ALTER TABLE "transaction"
    ADD CONSTRAINT "fk_transaction_merchant_id" FOREIGN KEY ("merchant_id")
        REFERENCES "merchant" ("id");

