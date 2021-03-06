DELETE FROM account;
DELETE FROM workspace;
DELETE FROM accountworkspace;
DELETE FROM channel;
DELETE FROM accountchannel;
DELETE FROM role;


INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('1', '$2a$10$eU4gRbKP1WWUczJpH9BI5.CEmdyROfZoAOFJYRzeUFp.UPgW766Ku', 'Saitama', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('asdf@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Superman', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('qwer@qwer', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Batman', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('zxcv@zxcv', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Spider-man', 'kor', 2, '1234-01-01', '9999-12-31');

INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('1111@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Captain America', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('2222@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Ironman', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('3333@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Wonder Woman', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('4444@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Deadpool', 'kor', 2, '1234-01-01', '9999-12-31');

INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('5555@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Antman', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('6666@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Hawkeye', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (email, password, name, country, status, createDt, modifyDt)
    VALUES ('7777@asdf', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Black Widow', 'kor', 2, '1234-01-01', '9999-12-31');
INSERT INTO account (id, email, password, name, country, status, createDt, modifyDt)
    VALUES (123456789123456, 'test@test', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', 'Big Integer Man', 'kor', 2, '1234-01-01', '9999-12-31');


INSERT INTO workspace(name, createDt, modifyDt) VALUES ('Heroes', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws2', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws3', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws4', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws5', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws6', '1234-01-01', '9999-12-31');


INSERT INTO role (name) VALUES ('normal_user');
INSERT INTO role (name) VALUES ('admin');
INSERT INTO role (name) VALUES ('owner');


INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'All Heroes', 'topic1', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'Marvel Heroes', 'topic2', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'DC Heroes', 'topic3', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'channel4', 'topic4', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'channel5', 'topic5', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (1, 'channel6', 'topic6', 'pagination test for channels in workspace', '1234-01-01', '9999-12-31');

INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (2, 'ws2-default-channel', 'topic7', 'pagination test for channels of one member', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (3, 'ws3-default-channel', 'topic8', 'pagination test for channels of one member', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (4, 'ws4-default-channel', 'topic9', 'pagination test for channels of one member', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (5, 'ws5-default-channel', 'topic10', 'pagination test for channels of one member', '1234-01-01', '9999-12-31');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (6, 'ws6-default-channel', 'topic11', 'pagination test for channels of one member', '1234-01-01', '9999-12-31');


INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 1, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 2, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 3, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 4, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 5, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (1, 6, 3);

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (2, 1, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (3, 1, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (4, 1, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (5, 1, 2);

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (6, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (7, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (8, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (9, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (10, 1, 1);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (11, 1, 1);


INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 1, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (2, 2, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (3, 3, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (4, 4, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (5, 5, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (6, 6, 3);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 7, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 8, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 9, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 10, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (1, 11, 3);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (2, 1, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (3, 1, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (4, 1, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (5, 1, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (6, 1, 2);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (7, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (8, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (9, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (10, 1, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (11, 1, 1);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (4, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (5, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (6, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (8, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (9, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (10, 2, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (11, 2, 1);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (2, 3, 1);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (7, 3, 1);
