import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import SubmitButton from '../../Common/SubmitButton';
import sampleImage from '../../../icon/sample-workspace.png';
import { IWorkspace } from '../../../../types/workspace.type';

const Item = styled.section`
  display: flex;
  justify-content: space-between;
  align-items: center;
  & + & {
    margin-top: 28px;
    border-top: 1px solid ${(props) => props.theme.color.lightGrey};
    padding-top: 20px;
  }
  @media only screen and (max-width: 550px) {
    flex-direction: column;
    align-items: baseline;
  }
`;

const ItemInfoLayer = styled.section`
  display: flex;
  align-items: center;
  @media only screen and (max-width: 550px) {
    margin-bottom: 12px;
  }
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

export default function WsItem({ ws }: { ws: IWorkspace }) {
  const navigate = useNavigate();
  const submitHandler = () => navigate('/' + ws.id);

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
        responsive={true}
        submitHandler={submitHandler}
      ></SubmitButton>
    </Item>
  );
}
