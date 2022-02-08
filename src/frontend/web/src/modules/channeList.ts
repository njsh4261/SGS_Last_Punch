const SET_CHANNEL_LIST = 'channelList/set';

export type ChannelListState = {
  id: number;
  name: string;
}[];

export const setChannelList = (channelList: ChannelListState) => ({
  type: SET_CHANNEL_LIST,
  channelList,
});

type ChannelListAction = ReturnType<typeof setChannelList>;

const initialChannelList: any[] = [];

export default function channelList(
  state = initialChannelList,
  action: ChannelListAction,
): ChannelListState {
  switch (action.type) {
    case SET_CHANNEL_LIST:
      return [...action.channelList];
      break;
    default:
      return state;
  }
}
