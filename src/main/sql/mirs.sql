# 电影智能推荐系统的数据库

DROP DATABASE mirs;
CREATE DATABASE mirs;

USE mirs;

DROP TABLE IF EXISTS mirs_register_session;
CREATE TABLE mirs_register_session(
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '注册会话编号',
  `create_time` DATETIME NOT NULL COMMENT '注册会话创建时间',
  `email` VARCHAR(200) NOT NULL COMMENT '验证成功邮件地址',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '注册会话状态：1：正在注册;2：注册超时;3注册失败;4:注册成功',
  `client_ip` VARCHAR(15) COMMENT '客服端IP地址',
  `expire_time` DATETIME NOT NULL COMMENT '注册会话过期时间',
  PRIMARY KEY (id),
  INDEX idx_email_address(email)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '注册会话表';


DROP TABLE IF EXISTS mirs_email_verify;
CREATE TABLE mirs_email_verify(
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '验证编号',
  `email` VARCHAR(200) NOT NULL COMMENT '验证邮箱地址',
  `create_time` DATETIME NOT NULL COMMENT '验证创建时间',
  `expire_time` DATETIME NOT NULL COMMENT '验证过期时间',
  `channel` CHAR(1) NOT NULL DEFAULT '1' COMMENT '验证渠道，默认为通过网站版验证:1;',
  `verify_code` VARCHAR(10) NOT NULL COMMENT '验证码',
  `verify_type` CHAR(1) NOT NULL COMMENT '验证类型：1：注册;2：找回密码;3:异地登录',
  `request_ip` VARCHAR(15) COMMENT '请求IP',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '验证状态：1:正在验证;2:验证超时;3:验证失败;4:验证成功',
  `parameter1` VARCHAR(200) COMMENT '额外参数1',
  `parameter2` VARCHAR(200) COMMENT '额外参数2',
  PRIMARY KEY (id)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '邮件验证表，验证登录注册，修改密码等';


DROP TABLE IF EXISTS mirs_email_template;
CREATE TABLE mirs_email_template(
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '邮件模板编号',
  `title` VARCHAR(200) NOT NULL COMMENT '邮件模板标题',
  `content` TEXT NOT NULL COMMENT '邮件模板内容',
  `sort` INT NOT NULL DEFAULT 100 COMMENT '邮件模板排序',
  `description` VARCHAR(200) COMMENT '邮件模板描述',
  `unique_identity` VARCHAR(50) COMMENT '邮件模板唯一标识',
  PRIMARY KEY (id)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '邮件模板表，用来保存常用的邮件模板';


DROP TABLE IF EXISTS mirs_user;
CREATE TABLE mirs_user(
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '用户唯一编号',
  `username` VARCHAR(100) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(128) COMMENT '密码',
  `salt` VARCHAR(128) COMMENT '盐值',
  `avatar` VARCHAR(100) COMMENT '用户头像地址',
  `email` VARCHAR(200) NOT NULL UNIQUE COMMENT '用户邮箱',
  `bio` VARCHAR(200) COMMENT '个人格言',
  `location` VARCHAR(100) COMMENT '地址',
  `university` VARCHAR(200) COMMENT '大学信息',
  `major` VARCHAR(100) COMMENT '专业信息',
  `status` CHAR(1) NOT NULL DEFAULT '1' COMMENT '用户状态：1：正常;2:停用',
  `last_login_time` DATETIME COMMENT '上次登录时间',
  `last_login_ip` VARCHAR(15) COMMENT '上次登录IP',
  `register_time` DATETIME COMMENT '注册时间',
  `register_ip` VARCHAR(15) COMMENT '注册IP',
  PRIMARY KEY (id),
  INDEX idx_user_name(username),
  INDEX idx_user_email(email)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '用户基本信息表';


DROP TABLE IF EXISTS mirs_oauth_user;
CREATE TABLE mirs_oauth_user(
  `id` INT NOT NULL AUTO_INCREMENT COMMENT 'OAuth编号',
  `u_id` INT NOT NULL COMMENT '用户编号',
  `oauth_type` VARCHAR(20) NOT NULL COMMENT 'OAuth认证方式',
  `oauth_id` VARCHAR(128) NOT NULL COMMENT '第三方返回的oauth_id',
  `oauth_access_token` VARCHAR(256) NOT NULL COMMENT '第三方返回的接口调用凭证',
  `oauth_expires` INT COMMENT 'access_token接口调用凭证超时时间，单位（秒）',
  `oauth_scope` VARCHAR(256) COMMENT '用户授权的作用域，使用逗号（,）分隔',
  PRIMARY KEY (id),
  INDEX idx_u_id(u_id)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '用户第三方授权信息表';


DROP TABLE IF EXISTS mirs_movie;
CREATE TABLE mirs_movie(
  `id` VARCHAR(12) NOT NULL COMMENT '电影id，现与豆瓣电影同步',
  `name` VARCHAR(60) COMMENT '电影名',
  `year` CHAR(4) COMMENT '电影发行年份',
  `directors` VARCHAR(60) COMMENT '电影导演',
  `screenwriters` VARCHAR(60) COMMENT '编剧',
  `actors` VARCHAR(100) COMMENT '相关演员',
  `types` VARCHAR(50) COMMENT '电影类型',
  `official_website` VARCHAR(50) COMMENT '官网',
  `origin_place` VARCHAR(10) COMMENT '',
  `release_date` VARCHAR(60) COMMENT '',
  `languages` VARCHAR(10) COMMENT '',
  `runtime` VARCHAR(40) COMMENT '',
  `another_names` VARCHAR(60) COMMENT '又名',
  `IMDb_link` VARCHAR(20) COMMENT '',
  `synopsis` VARCHAR(1000) COMMENT '剧情简介',
  `stills_link` VARCHAR(30) COMMENT '剧照页面链接',
  `stills_photos_links` VARCHAR(1000) DEFAULT '' COMMENT '剧照照片集合页面链接',
  `poster_link` VARCHAR(30) COMMENT '海报',
  `poster_photos_links` VARCHAR(500) DEFAULT '' COMMENT '海报照片集合页面链接',
  `wallpaper_link` VARCHAR(30) COMMENT '壁纸',
  `wallpaper_photos_links` VARCHAR(300) DEFAULT '' COMMENT '壁纸照片集合页面链接',
  `awards` VARCHAR(300) COMMENT '获奖',
  `also_like_movies` VARCHAR(200) COMMENT '喜欢这部电影的人同样喜欢的电影',
  `questions` JSON COMMENT '关于这部电影的几个问题',
  `all_questions_link` VARCHAR(20) COMMENT '关于这部电影所有问题的页面链接',
  `reviews` JSON COMMENT '几个影评',
  `reviews_link` VARCHAR(20) COMMENT '所有影评页面链接',
  `short_pop_comments` JSON COMMENT '几个最新短评',
  `short_new_comments` JSON COMMENT '几个热门短评',
  `short_comments_link` VARCHAR(20) COMMENT '所有短评页面链接',
  PRIMARY KEY (id),
  INDEX idx_id(id)
)ENGINE = InnoDB DEFAULT CHARSET = utf8 COMMENT '电影基本信息表';




















