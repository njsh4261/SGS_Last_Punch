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


INSERT INTO role (name) VALUES ('normal_user');
INSERT INTO role (name) VALUES ('admin');
INSERT INTO role (name) VALUES ('owner');


INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel1', 'topic1', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel2', 'topic2', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel3', 'topic3', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel4', 'topic4', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel5', 'topic5', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (1, 'channel6', 'topic6', 'pagination test for channels in workspace', 1, 2, '1234-01-01', '9999-12-31');

INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 'channel7', 'topic7', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (3, 'channel8', 'topic8', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (4, 'channel9', 'topic9', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (5, 'channel10', 'topic10', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (6, 'channel11', 'topic11', 'pagination test for channels of one member', 1, 2, '1234-01-01', '9999-12-31');

INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 'channel12', 'topic12', 'channels', 1, 2, '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, settings, status, createDt, modifyDt)
    VALUES (2, 'channel13', 'topic13', 'channels', 1, 2, '1234-01-01', '9999-12-31');


INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 1, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 2, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 3, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 4, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 5, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 6, 2);

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (2, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (2, 2, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (2, 3, 1);

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 2, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 3, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 4, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 5, 2);

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (4, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (5, 1, 1);


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