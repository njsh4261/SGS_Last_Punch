DROP DATABASE workspace_test;
CREATE DATABASE workspace_test default character set utf8;
USE workspace_test;

source C:/github/SGS_Last_Punch/scripts/MySQL/LastPunch_schema.sql

DELETE FROM account;
DELETE FROM workspace;
DELETE FROM accountworkspace;
DELETE FROM channel;
DELETE FROM accountchannel;
DELETE FROM role;


INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('asdf@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('qwer@qwer', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('zxcv@zxcv', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('1111@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('2222@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('3333@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('4444@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('5555@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('6666@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, language, settings, status, level, point, createDt, modifyDt)
    VALUES ('7777@asdf', 'pw', 'name', 'kor', 'eng', 1, 2, 3, 123, '1234-01-01', '9999-12-31');


INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws1', 0, 1, '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws2', 0, 1, '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws3', 0, 1, '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws4', 0, 1, '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws5', 0, 1, '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, settings, status, createDt, modifyDt)
    VALUES ('ws6', 0, 1, '1234-01-01', '9999-12-31');


INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 1);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 2);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 3);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 4);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 5);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (1, 6);

INSERT INTO accountworkspace (accountId, workspaceId) VALUES (2, 1);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (2, 2);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (2, 3);

INSERT INTO accountworkspace (accountId, workspaceId) VALUES (3, 1);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (3, 2);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (3, 3);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (3, 4);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (3, 5);

INSERT INTO accountworkspace (accountId, workspaceId) VALUES (4, 1);
INSERT INTO accountworkspace (accountId, workspaceId) VALUES (5, 1);


INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 1, 'channel1', 'topic1', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 2, 'channel2', 'topic2', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 3, 'channel3', 'topic3', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 4, 'channel4', 'topic4', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 5, 'channel5', 'topic5', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 6, 'channel6', 'topic6', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');

INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 1, 'channel7', 'topic7', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (3, 1, 'channel8', 'topic8', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (4, 1, 'channel9', 'topic9', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (5, 1, 'channel10', 'topic10', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (6, 1, 'channel11', 'topic11', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');

INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 2, 'channel12', 'topic12', 'channels', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, creatorId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 3, 'channel13', 'topic13', 'channels', 1, 2, '1234-01-01', '9999-12-31');


INSERT INTO role (name) VALUES ('normal_user');
INSERT INTO role (name) VALUES ('channel_admin');


INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 1, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (2, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (3, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (4, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (5, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (6, 1, 1);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 2, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 3, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 4, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 5 ,2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 6, 1);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (3, 3, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (6, 5, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (9, 7, 1);
