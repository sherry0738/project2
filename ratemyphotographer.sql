CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(400) NOT NULL,
	email VARCHAR(300) NOT NULL,
	password_digest VARCHAR(400),
	created_at TIMESTAMP   
);

CREATE TABLE photographers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(400),	
	image_url VARCHAR(500),
	phone VARCHAR(70),
	address VARCHAR(700),
	rate INTEGER,
	website VARCHAR(500),
	created_by INTEGER,
	created_at TIMESTAMP,
	FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	content VARCHAR(500) NOT NULL,
	photographer_id INTEGER NOT NULL,
	rate INTEGER NOT NULL,
	created_by INTEGER,
	created_at TIMESTAMP,
	FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
	FOREIGN KEY (photographer_id) REFERENCES photographers (id) ON DELETE RESTRICT
);



