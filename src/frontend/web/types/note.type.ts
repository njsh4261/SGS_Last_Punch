interface OP {
  op: string; // need json parsing
  timestamp: string;
}

export interface Note {
  id: string;
  title: string;
  content: string;
  ops: OP[];
}
