CREATE TABLE `articles` (
	`id` text PRIMARY KEY NOT NULL,
	`slug` text NOT NULL,
	`title` text NOT NULL,
	`title_ar` text DEFAULT '',
	`excerpt` text DEFAULT '',
	`excerpt_ar` text DEFAULT '',
	`content` text NOT NULL,
	`content_ar` text DEFAULT '',
	`published` integer DEFAULT 0 NOT NULL,
	`updated` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `articles_slug_unique` ON `articles` (`slug`);--> statement-breakpoint
CREATE TABLE `bookings` (
	`id` text PRIMARY KEY NOT NULL,
	`reference` text NOT NULL,
	`user_id` text NOT NULL,
	`destination` text NOT NULL,
	`container` text NOT NULL,
	`type` text NOT NULL,
	`ship_date` text NOT NULL,
	`price` real,
	`currency` text DEFAULT 'USD' NOT NULL,
	`quantity` integer NOT NULL,
	`cargo` text NOT NULL,
	`weight` text DEFAULT '',
	`volume` text DEFAULT '',
	`notes` text DEFAULT '',
	`status` text DEFAULT 'requested' NOT NULL,
	`request_key` text NOT NULL,
	`created` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `bookings_reference_unique` ON `bookings` (`reference`);--> statement-breakpoint
CREATE UNIQUE INDEX `bookings_request_unique` ON `bookings` (`user_id`,`request_key`);--> statement-breakpoint
CREATE INDEX `bookings_user_date` ON `bookings` (`user_id`,`created`);--> statement-breakpoint
CREATE TABLE `companies` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`name` text NOT NULL,
	`volume` text,
	`verification` text DEFAULT 'unverified' NOT NULL,
	`reason` text DEFAULT '',
	`notes` text DEFAULT '',
	`updated` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `companies_user_unique` ON `companies` (`user_id`);--> statement-breakpoint
CREATE TABLE `documents` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`kind` text NOT NULL,
	`object_key` text NOT NULL,
	`name` text NOT NULL,
	`type` text NOT NULL,
	`size` integer NOT NULL,
	`created` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `documents_user` ON `documents` (`user_id`);--> statement-breakpoint
CREATE TABLE `enquiries` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`company` text NOT NULL,
	`email` text NOT NULL,
	`phone` text NOT NULL,
	`message` text NOT NULL,
	`status` text DEFAULT 'new' NOT NULL,
	`created` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `events` (
	`id` text PRIMARY KEY NOT NULL,
	`shipment_id` text NOT NULL,
	`status` integer NOT NULL,
	`note` text DEFAULT '',
	`created` text NOT NULL,
	FOREIGN KEY (`shipment_id`) REFERENCES `shipments`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `events_shipment_date` ON `events` (`shipment_id`,`created`);--> statement-breakpoint
CREATE TABLE `guests` (
	`id` text PRIMARY KEY NOT NULL,
	`used` integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE `limits` (
	`key` text PRIMARY KEY NOT NULL,
	`count` integer NOT NULL,
	`reset` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `ports` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`ar` text NOT NULL,
	`country` text NOT NULL,
	`region` text NOT NULL,
	`enabled` integer DEFAULT 1 NOT NULL
);
--> statement-breakpoint
CREATE TABLE `rates` (
	`id` text PRIMARY KEY NOT NULL,
	`destination` text NOT NULL,
	`size` integer NOT NULL,
	`price` real NOT NULL,
	`currency` text DEFAULT 'USD' NOT NULL,
	`line` text DEFAULT '',
	`transit` text DEFAULT '',
	`valid_until` text DEFAULT '',
	`enabled` integer DEFAULT 1 NOT NULL,
	`updated` text NOT NULL,
	FOREIGN KEY (`destination`) REFERENCES `ports`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `rates_route_size_unique` ON `rates` (`destination`,`size`);--> statement-breakpoint
CREATE TABLE `searches` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text,
	`anon` text,
	`destination` text NOT NULL,
	`container` text NOT NULL,
	`type` text NOT NULL,
	`ship_date` text NOT NULL,
	`created` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `searches_user_date` ON `searches` (`user_id`,`created`);--> statement-breakpoint
CREATE INDEX `searches_destination` ON `searches` (`destination`);--> statement-breakpoint
CREATE TABLE `sessions` (
	`token` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`expires` integer NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `sessions_user` ON `sessions` (`user_id`);--> statement-breakpoint
CREATE TABLE `settings` (
	`key` text PRIMARY KEY NOT NULL,
	`value` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `shipments` (
	`id` text PRIMARY KEY NOT NULL,
	`booking_id` text,
	`user_id` text NOT NULL,
	`reference` text NOT NULL,
	`bl` text DEFAULT '',
	`container` text DEFAULT '',
	`destination` text NOT NULL,
	`status` integer DEFAULT 0 NOT NULL,
	`vessel` text DEFAULT '',
	`eta` text DEFAULT '',
	`updated` text NOT NULL,
	FOREIGN KEY (`booking_id`) REFERENCES `bookings`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `shipments_reference_unique` ON `shipments` (`reference`);--> statement-breakpoint
CREATE INDEX `shipments_bl` ON `shipments` (`bl`);--> statement-breakpoint
CREATE INDEX `shipments_container` ON `shipments` (`container`);--> statement-breakpoint
CREATE INDEX `shipments_user` ON `shipments` (`user_id`);--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`email` text NOT NULL,
	`name` text NOT NULL,
	`phone` text DEFAULT '' NOT NULL,
	`password` text NOT NULL,
	`role` text DEFAULT 'customer' NOT NULL,
	`created` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);