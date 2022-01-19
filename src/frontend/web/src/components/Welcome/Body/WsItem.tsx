import React from 'react';
import { useDispatch } from 'react-redux';
import { selectWork } from '../../../modules/worksapce';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import SubmitButton from '../../Common/SubmitButton';
import sampleImage from '../../../icon/sample-workspace.png';

const Item = styled.section`
  display: flex;
  flex-direction: column;
  & + & {
    margin-top: 28px;
    border-top: 1px solid ${(props) => props.theme.color.lightGrey};
    padding-top: 20px;
  }
`;

const ItemInfoLayer = styled.section`
  display: flex;
  margin-bottom: 12px;
  align-items: center;
`;

const WorkSpaceImage = styled.div`
  width: 75px;
  height: 75px;
  background-image: url(${sampleImage});
  margin-right: 16px;
  border-radius: 5px;
`;

const WorkSpaceInfo = styled.div`
  display: flex;
  flex-direction: column;
`;

const WorkSpaceName = styled.section`
  font-weight: 700;
  padding-bottom: 10px;
`;

const WorkSpaceMembers = styled.section`
  font-weight: 400;
  color: grey;
  font-size: 14px;
`;

export interface WsItemProps {
  id: number; // todo: 바뀔수 있음
  name: string;
  description: string | null;
  setting: number;
  status: number;
}

export default function WsItem({ ws }: { ws: WsItemProps }) {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const submitHandler = () => dispatch(selectWork(ws.id, navigate));

  return (
    <Item key={ws.id}>
      <ItemInfoLayer>
        <WorkSpaceImage></WorkSpaceImage>
        <WorkSpaceInfo>
          <WorkSpaceName>{ws.name}</WorkSpaceName>
          <WorkSpaceMembers>x명의 멤버</WorkSpaceMembers>
        </WorkSpaceInfo>
      </ItemInfoLayer>
      <SubmitButton
        fontSize="14px"
        fontWeight="400"
        text="Let's Snack"
        borderRadius="5px"
        light={true}
        submitHandler={submitHandler}
      ></SubmitButton>
    </Item>
  );
}
