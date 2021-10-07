# Modifier le prefix des tables de Wordpress
## 1 – Modifer WP-CONFIG.PHP
Modifier $table_prefix
`$table_prefix  = 'NOUVEAU-PREFIX_';`

## Copier le code

Modifier les variable suivates dans le [code source](https://raw.githubusercontent.com/picfab/WP_rename_prefix_SQL_request/main/rename%20prefix%20wordpress.sql) :

- @database  = "NOM_DE_LA_BASE_DE_DONNEES";
- @oldprefix = "wp_";
- @newprefix = "NOUVEAUX-PREFIX_";

## Modifier votre base de donnée
1. Dans phpMyAdmin, sélectionnez votre base de donnée.
2. Copier le nouveau code SQL dans l'onglet SQL de votre phpMyAdmin.
3. Lancez la requête.

Le tour est joué.

![Capture de phpMyAdmin](/PHPMYADMIN.png)


