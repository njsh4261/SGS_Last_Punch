import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import { useSelector } from 'react-redux';

import { RootState } from '../../../modules';
import { exitChannelAPI, getChannelInfoAPI } from '../../../Api/channel';
import { exitWsAPI, getWsInfoAPI } from '../../../Api/workspace';
import { IChannel } from '../../../../types/channel.type';
import { IWorkspace } from '../../../../types/workspace.type';
import { Params } from 'react-router-dom';
import Loading from '../Loading';

const Container = styled.article`
  margin: 18px 28px;
  border: 1px solid lightgray;
  border-radius: 6px;
  overflow: hidden;
`;

const ItemBox = styled.section`
  padding: 16px 20px;
  border-bottom: 1px solid lightgray;
  background-color: white;
  :hover {
    background-color: #f6f6f6;
    cursor: pointer;
  }
  :last-child {
    border-bottom: none;
    color: #e01e5a;
  }
`;

const ItemL1 = styled.div`
  font-weight: bold;
  display: flex;
  justify-content: space-between;
`;

const ItemL1Edit = styled.div`
  color: #1264a3;
  font-size: 14px;
`;

const ItemL2 = styled.div`
  margin-top: 4px;
  opacity: 50%;
`;

interface Props {
  type: 'channel' | 'workspace';
  params: Params;
}

export default function ModalInfo({ type, params }: Props) {
  const [ws, setWs] = useState<IWorkspace | undefined>();
  const [channel, setChannel] = useState<IChannel | undefined>();
  const user = useSelector((state: RootState) => state.user);

  const exitHandler = async () => {
    let response;
    if (type === 'channel' && channel) {
      response = await exitChannelAPI(user.id, +channel.id);
    } else if (ws) {
      response = await exitWsAPI(ws.id, user.id);
    }
    console.log({ response });
  };

  const getInfoHandler = async () => {
    if (type === 'channel' && params.channelId) {
      const response = await getChannelInfoAPI(params.channelId);
      setChannel(response.channel);
    } else if (type === 'workspace' && params.wsId) {
      const response = await getWsInfoAPI(+params.wsId);
      setWs(response.workspace);
    }
  };

  useEffect(() => {
    getInfoHandler();
  }, []);

  return (
    <>
      {!channel && !ws ? (
        <Loading></Loading>
      ) : (
        <Container>
          {type === 'channel' && (
            <ItemBox>
              <ItemL1>
                <div>주제</div>
                <ItemL1Edit>편집</ItemL1Edit>
              </ItemL1>
              <ItemL2>
                {channel!.topic !== null ? channel!.topic : '주제 추가'}
              </ItemL2>
            </ItemBox>
          )}
          <ItemBox>
            <ItemL1>
              <div>설명</div>
              <ItemL1Edit>편집</ItemL1Edit>
            </ItemL1>
            <ItemL2>
              {type === 'channel'
                ? channel!.description !== null
                  ? channel!.description
                  : '설명 추가'
                : ws!.description !== null
                ? ws!.description
                : '설명 추가'}
            </ItemL2>
          </ItemBox>
          <ItemBox>
            <ItemL1>
              <div>소유자</div>
            </ItemL1>
            <ItemL2>
              {type === 'channel'
                ? '소유자: [소유자이름], 생성 날짜: ' +
                  channel!.createDt.split(' ')[0]
                : '소유자: [소유자이름], 생성 날짜: ' +
                  ws!.createDt.split(' ')[0]}
            </ItemL2>
          </ItemBox>
          <ItemBox onClick={exitHandler}>
            <ItemL1>
              {type === 'channel' ? '채널' : '워크스페이스'}에서 나가기
            </ItemL1>
          </ItemBox>
        </Container>
      )}
    </>
  );
}
