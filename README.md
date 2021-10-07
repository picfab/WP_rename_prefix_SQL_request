# Modifier le prefix des tables de Wordpress
## 1. Modifer WP-CONFIG.PHP
Modifiez $table_prefix

`$table_prefix  = 'NOUVEAU-PREFIX_';`

## 2. Copier le code

Modifiez les variable suivates dans le [code source](https://raw.githubusercontent.com/picfab/WP_rename_prefix_SQL_request/main/rename%20prefix%20wordpress.sql){:target="_blank"} :

- @database  = "NOM_DE_LA_BASE_DE_DONNEES";
- @oldprefix = "wp_";
- @newprefix = "NOUVEAUX-PREFIX_";

## 3. Modifier votre base de donnée
1. Dans phpMyAdmin, sélectionnez votre base de donnée.
2. Copier le code avec les variables modifier dans l'onglet SQL de votre phpMyAdmin.
3. Lancez la requête.

Le tour est joué.

![Capture de phpMyAdmin](/PHPMYADMIN.png)


