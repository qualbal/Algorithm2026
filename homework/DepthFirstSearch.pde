import java.util.*;

int n, m, step = 0;
ArrayList<Integer>[] adj;
ArrayList<Edge> edges;
ArrayList<Integer> order = new ArrayList<Integer>();
ArrayList<ArrayList<Integer>> history = new ArrayList<ArrayList<Integer>>();
PVector[] pos;

class Edge {
  int a, b;
  Edge(int a, int b) {
    this.a = a;
    this.b = b;
  }
}

void setup() {
  size(1100, 720);
  textFont(createFont("Arial", 15));
  generateGraph();
}

// GRAPH GENERATION
void generateGraph() {
  n = (int)random(5, 11);
  m = (int)random(n - 1, min(n * (n - 1) / 2, n * 2) + 1);

  adj = new ArrayList[n];
  edges = new ArrayList<Edge>();

  for (int i = 0; i < n; i++)
    adj[i] = new ArrayList<Integer>();

  boolean[][] used = new boolean[n][n];

  for (int i = 1; i < n; i++)
    addEdge((int)random(i), i, used);

  while (edges.size() < m) {
    int a = (int)random(n);
    int b = (int)random(n);

    if (a != b && !used[a][b])
      addEdge(a, b, used);
  }

  for (int i = 0; i < n; i++)
    Collections.sort(adj[i]);

  pos = new PVector[n];

  for (int i = 0; i < n; i++) {
    float angle = TWO_PI * i / n - HALF_PI;
    pos[i] = new PVector(
      330 + 245 * cos(angle),
      355 + 245 * sin(angle)
    );
  }

  runDFS();
}

void addEdge(int a, int b, boolean[][] used) {
  used[a][b] = true;
  used[b][a] = true;
  adj[a].add(b);
  adj[b].add(a);
  edges.add(new Edge(a, b));
}

// DFS
void runDFS() {
  order.clear();
  history.clear();
  step = 0;

  boolean[] visited = new boolean[n];
  ArrayList<Integer> stack = new ArrayList<Integer>();

  stack.add(0);
  visited[0] = true;
  order.add(0);

  history.add(new ArrayList<Integer>(stack));

  while (!stack.isEmpty()) {
    int current = stack.get(stack.size() - 1);
    int nextVertex = -1;

    // Find smallest unvisited neighbor
    for (int next : adj[current]) {
      if (!visited[next]) {
        nextVertex = next;
        break;
      }
    }

    if (nextVertex != -1) {
      visited[nextVertex] = true;
      stack.add(nextVertex);
      order.add(nextVertex);
    } else {
      stack.remove(stack.size() - 1);
    }

    history.add(new ArrayList<Integer>(stack));
  }
}

// DRAW
void draw() {
  background(248);

  fill(30);
  textSize(25);
  text("DFS - Depth First Search", 30, 35);

  textSize(15);
  fill(100);
  text("Vertices: " + n + "   Edges: " + m + "   Start: 0", 30, 65);

  // Edges
  stroke(130);
  strokeWeight(2.5);

  for (Edge e : edges)
    line(pos[e.a].x, pos[e.a].y, pos[e.b].x, pos[e.b].y);

  // Vertices
  for (int i = 0; i < n; i++) {
    boolean visited = false;

    for (int j = 0; j < step; j++)
      if (order.get(j) == i)
        visited = true;

    boolean current = step > 0 && order.get(step - 1) == i;

    if (current) fill(255, 165, 40);
    else if (visited) fill(60, 180, 110);
    else fill(65, 135, 220);

    stroke(30);
    ellipse(pos[i].x, pos[i].y, 48, 48);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(19);
    text(i, pos[i].x, pos[i].y);
  }

  // Information
  int x = 700;

  fill(30);
  textAlign(LEFT);
  textSize(21);
  text("Ordered Pairs", x, 115);

  textSize(14);
  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);
    text("(" + e.a + ", " + e.b + ")",
      x + (i % 3) * 110,
      150 + (i / 3) * 23);
  }

  int y = 180 + ((edges.size() + 2) / 3) * 23;

  fill(30);
  textSize(21);
  text("DFS Traversal", x, y);

  fill(80);
  textSize(15);
  text("Start Vertex: 0", x, y + 40);
  text("Traversal Order:", x, y + 75);

  String result = "";
  for (int i = 0; i < step; i++)
    result += order.get(i) + " ";

  fill(30);
  textSize(19);
  text(result, x, y + 110);

  fill(80);
  textSize(15);
  text("Progress: " + step + " / " + order.size(), x, y + 145);
  text("Stack:", x, y + 185);

  String s = "";
  for (int v : history.get(step))
    s += "[" + v + "] ";

  fill(30);
  textSize(18);
  text(s, x, y + 215);

  fill(100);
  textSize(12);
  text("Rightmost = Stack Top", x, y + 240);

  fill(30);
  textSize(15);
  text("SPACE : Next Step", 700, 650);
  text("R : New Random Graph", 700, 680);
  textAlign(LEFT);
}

void keyPressed() {
  if (key == ' ' && step < order.size())
    step++;

  if (key == 'r' || key == 'R')
    generateGraph();
}
