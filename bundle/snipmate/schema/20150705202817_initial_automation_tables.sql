--
-- controllers
--
CREATE TABLE controllers
(
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  CONSTRAINT pk_controllers PRIMARY KEY (id),
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  name text NOT NULL,
  clazz text NOT NULL
);

CREATE TRIGGER tg_controllers_timestamp
BEFORE UPDATE ON controllers FOR EACH ROW
EXECUTE PROCEDURE fn_timestamp();

