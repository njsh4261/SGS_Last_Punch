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
INSERT INTO account (id, email, password, name, country, status, imageNum, createDt, modifyDt)
    VALUES (13, 'geonhyeong.dev@gmail.com', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', '김건형', 'kor', 2, 21, '1234-01-01', '9999-12-31');
INSERT INTO account (id, email, password, name, country, status, imageNum, createDt, modifyDt)
    VALUES (14, 'ohjskim@gmail.com', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', '김지수', 'kor', 2, 23, '1234-01-01', '9999-12-31');
INSERT INTO account (id, email, password, name, country, status, imageNum, createDt, modifyDt)
    VALUES (15, 'chahtk@gmail.com', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', '차효준', 'kor', 2, 22, '1234-01-01', '9999-12-31');
INSERT INTO account (id, email, password, name, country, status, imageNum, createDt, modifyDt)
    VALUES (16, 'njsh4261@gmail.com', '$2a$10$BkGjbK/UK9NiwgWEvYdRoedRDPhP1Nhh/ttog4eI8eBdvq3CCXhJC', '김지효', 'kor', 2, 24, '1234-01-01', '9999-12-31');



INSERT INTO workspace(name, createDt, modifyDt) VALUES ('Heroes', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws2', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws3', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws4', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws5', '1234-01-01', '9999-12-31');
INSERT INTO workspace(name, createDt, modifyDt) VALUES ('ws6', '1234-01-01', '9999-12-31');

INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('Stove Dev Camp 2기', '1234-01-01', '9999-12-31', 7);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('로스트아크팀', '1234-01-01', '9999-12-31', 9);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('크로스파이어팀', '1234-01-01', '9999-12-31', 10);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('Smilegate Stove', '1234-01-01', '9999-12-31', 1);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('Smilegate RPG', '1234-01-01', '9999-12-31', 2);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('Smilegate Holdings', '1234-01-01', '9999-12-31', 3);
INSERT INTO workspace(name, createDt, modifyDt, imageNum) VALUES ('Smilegate Investment', '1234-01-01', '9999-12-31', 4);



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

INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '공지사항', '공지사항', '공지사항을 위한 채널입니다.', '2020-07-14', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '일정', '일정', '전체 일정 관리를 위한 채널입니다.', '2020-09-14', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '이슈', '이슈', '주요 이슈를 적기 위한 채널입니다', '2020-08-10', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '인사팀', '인사', '인사팀을 위한 채널입니다', '2020-08-10', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '웹서비스개발팀', '웹서비스개발', '웹서비스개발팀을 위한 채널입니다', '2020-08-10', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '서비스플랫폼개발팀', '서비스플랫폼개발', '서비스플랫폼개발팀을 위한 채널입니다', '2020-08-10', '2022-02-19');
INSERT INTO channel (workspaceId, name, topic, description, createDt, modifyDt)
    VALUES (10, '모바일개발팀', '모바일개발', '모바일개발팀을 위한 채널입니다', '2020-08-10', '2022-02-19');

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

INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 7, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 8, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 9, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 10, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 11, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 12, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (13, 13, 3);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (14, 10, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (15, 10, 2);
INSERT INTO accountworkspace (accountId, workspaceId, roleId) VALUES (16, 10, 2);


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

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 12, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 13, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 14, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 15, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 16, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 17, 3);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (13, 18, 3);

INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 12, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 13, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 14, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 15, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 16, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 17, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (14, 18, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 12, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 13, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 14, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 15, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 16, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 17, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (15, 18, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 12, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 13, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 14, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 15, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 16, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 17, 2);
INSERT INTO accountchannel (accountId, channelId, roleId) VALUES (16, 18, 2);

