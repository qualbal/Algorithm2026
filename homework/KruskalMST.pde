import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

ArrayList<Node> nodes;
ArrayList<Edge> edges;
ArrayList<Edge> mstEdges;

int[] parent;
int currentEdgeIndex = 0;
int totalWeight = 0;
boolean finished = false;
boolean autoPlay = false;
int lastStepTime = 0;

void setup() {
  size(960, 600);
  smooth();
  textFont(createFont("SansSerif", 14));
  initGraph(9, 16);
}

void draw() {
  background(245, 247, 250);

  if (autoPlay && !finished && millis() - lastStepTime > 700) {
    stepKruskal();
    lastStepTime = millis();
  }

  drawEdges();
  drawNodes();
  drawHUD();
}

void keyPressed() {
  if (key == ' ') {
    stepKruskal();
  } else if (key == 'a' || key == 'A') {
    autoPlay = !autoPlay;
  } else if (key == 'r' || key == 'R') {
    initGraph(9, 16);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    stepKruskal();
  }
}

void initGraph(int numNodes, int numEdges) {
  nodes = new ArrayList<Node>();
  edges = new ArrayList<Edge>();
  mstEdges = new ArrayList<Edge>();

  currentEdgeIndex = 0;
  totalWeight = 0;
  finished = false;
  autoPlay = false;

  int marginX = 80;
  int marginY = 90;
  int graphWidth = 620;
  int graphHeight = height - 140;

  // 1. 정점 배치 (겹치지 않게 생성)
  for (int i = 0; i < numNodes; i++) {
    float x = 0;
    float y = 0;
    boolean valid;
    int attempts = 0;

    do {
      valid = true;
      x = random(marginX, graphWidth);
      y = random(marginY, marginY + graphHeight);
      for (Node n : nodes) {
        if (dist(x, y, n.x, n.y) < 75) {
          valid = false;
          break;
        }
      }
      attempts++;
    } while (!valid && attempts < 200);

    nodes.add(new Node(i, x, y));
  }

  // 2. 그래프 연결성을 보장하기 위한 기본 간선 생성
  for (int i = 1; i < numNodes; i++) {
    int prev = int(random(0, i));
    int w = int(random(1, 20));
    edges.add(new Edge(prev, i, w));
  }

  // 3. 추가 랜덤 간선 생성
  int guard = 0;
  while (edges.size() < numEdges && guard < 500) {
    int u = int(random(0, numNodes));
    int v = int(random(0, numNodes));
    if (u != v && !hasEdge(u, v)) {
      int w = int(random(1, 25));
      edges.add(new Edge(u, v, w));
    }
    guard++;
  }

  // 4. 간선 가중치 오름차순 정렬
  Collections.sort(edges, new Comparator<Edge>() {
    public int compare(Edge a, Edge b) {
      return a.weight - b.weight;
    }
  });

  // 5. Union-Find 배열 초기화
  parent = new int[numNodes];
  for (int i = 0; i < numNodes; i++) {
    parent[i] = i;
  }
}

boolean hasEdge(int u, int v) {
  for (Edge e : edges) {
    if ((e.u == u && e.v == v) || (e.u == v && e.v == u)) {
      return true;
    }
  }
  return false;
}

int findSet(int x) {
  if (parent[x] == x) {
    return x;
  }
  parent[x] = findSet(parent[x]);
  return parent[x];
}

void unionSets(int a, int b) {
  int rootA = findSet(a);
  int rootB = findSet(b);
  if (rootA != rootB) {
    parent[rootB] = rootA;
  }
}

void stepKruskal() {
  if (finished) return;

  if (mstEdges.size() >= nodes.size() - 1 || currentEdgeIndex >= edges.size()) {
    finished = true;
    autoPlay = false;
    return;
  }

  Edge current = edges.get(currentEdgeIndex);
  int rootU = findSet(current.u);
  int rootV = findSet(current.v);

  if (rootU != rootV) {
    unionSets(rootU, rootV);
    mstEdges.add(current);
    totalWeight += current.weight;
    current.state = 1; // MST 채택
  } else {
    current.state = 2; // 사이클 발생으로 제외
  }

  currentEdgeIndex++;

  if (mstEdges.size() >= nodes.size() - 1 || currentEdgeIndex >= edges.size()) {
    finished = true;
    autoPlay = false;
  }
}

void drawEdges() {
  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);
    Node n1 = nodes.get(e.u);
    Node n2 = nodes.get(e.v);

    boolean isCurrent = (!finished && i == currentEdgeIndex);

    pushStyle();
    if (isCurrent) {
      stroke(245, 158, 11);
      strokeWeight(5);
      line(n1.x, n1.y, n2.x, n2.y);
    } else if (e.state == 1) {
      stroke(16, 185, 129);
      strokeWeight(4.5);
      line(n1.x, n1.y, n2.x, n2.y);
    } else if (e.state == 2) {
      stroke(239, 68, 68, 140);
      strokeWeight(2);
      dashedLine(n1.x, n1.y, n2.x, n2.y, 7, 5);
    } else {
      stroke(180, 188, 198);
      strokeWeight(2);
      line(n1.x, n1.y, n2.x, n2.y);
    }

    // 간선 가중치 박스
    float mx = (n1.x + n2.x) * 0.5;
    float my = (n1.y + n2.y) * 0.5;
    fill(255);
    stroke(150);
    strokeWeight(1);
    rectMode(CENTER);
    rect(mx, my, 28, 20, 4);

    fill(30);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(e.weight, mx, my);
    popStyle();
  }
}

void dashedLine(float x1, float y1, float x2, float y2, float dashLen, float gapLen) {
  float totalDist = dist(x1, y1, x2, y2);
  if (totalDist <= 0.001) return;

  float step = dashLen + gapLen;
  for (float d = 0; d < totalDist; d += step) {
    float t1 = d / totalDist;
    float t2 = min((d + dashLen) / totalDist, 1.0);
    float sx = lerp(x1, x2, t1);
    float sy = lerp(y1, y2, t1);
    float ex = lerp(x1, x2, t2);
    float ey = lerp(y1, y2, t2);
    line(sx, sy, ex, ey);
  }
}

void drawNodes() {
  for (Node n : nodes) {
    pushStyle();
    fill(37, 99, 235);
    stroke(255);
    strokeWeight(2.5);
    ellipse(n.x, n.y, 34, 34);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(n.id, n.x, n.y);

    fill(71, 85, 105);
    textSize(11);
    text("set:" + findSet(n.id), n.x, n.y + 24);
    popStyle();
  }
}

void drawHUD() {
  int panelX = 710;
  pushStyle();
  fill(255);
  stroke(220);
  strokeWeight(1);
  rectMode(CORNER);
  rect(panelX, 20, 230, height - 40, 10);

  fill(15, 23, 42);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Kruskal's MST", panelX + 16, 36);

  textSize(13);
  fill(51, 65, 85);
  int needed = max(0, nodes.size() - 1);
  text("MST Edges: " + mstEdges.size() + " / " + needed, panelX + 16, 68);
  text("Total Weight: " + totalWeight, panelX + 16, 90);
  text("Status: " + (finished ? "Completed" : (autoPlay ? "Auto Running" : "Paused")), panelX + 16, 112);

  textSize(12);
  fill(100, 116, 139);
  text("Sorted Edges (u - v : w)", panelX + 16, 146);

  int listY = 168;
  for (int i = 0; i < edges.size() && listY < height - 115; i++) {
    Edge e = edges.get(i);
    if (!finished && i == currentEdgeIndex) {
      fill(217, 119, 6);
    } else if (e.state == 1) {
      fill(5, 150, 105);
    } else if (e.state == 2) {
      fill(220, 38, 38);
    } else {
      fill(71, 85, 105);
    }
    text((i + 1) + ". (" + e.u + " - " + e.v + ")  w = " + e.weight, panelX + 16, listY);
    listY += 18;
  }

  fill(30, 41, 59);
  textSize(12);
  text("Click / SPACE : Next Step", panelX + 16, height - 88);
  text("A : Toggle Auto Play", panelX + 16, height - 68);
  text("R : New Random Graph", panelX + 16, height - 48);
  popStyle();
}

class Node {
  int id;
  float x, y;

  Node(int id, float x, float y) {
    this.id = id;
    this.x = x;
    this.y = y;
  }
}

class Edge {
  int u, v, weight;
  int state = 0; // 0: 대기, 1: MST 채택, 2: 제외

  Edge(int u, int v, int weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }
}
