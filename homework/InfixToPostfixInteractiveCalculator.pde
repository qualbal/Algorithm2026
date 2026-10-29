import java.util.Stack;

String userInput = "3 + ( 14 * 5 ) - 6 / 2"; // 기본 예시 수식 (입력창에 표시됨)
String postfixResult = "";
String calculationResult = "";
String errorMessage = "";

void setup() {
  size(700, 450);
  // 글꼴 설정 (가독성을 위한 기본 폰트 크기 지정)
  textFont(createFont("SansSerif", 18));
  
  // 시작할 때 기본 예시 수식으로 먼저 계산 진행
  processExpression(userInput);
}

void draw() {
  background(245, 247, 250); // 깔끔한 연회색 배경
  
  // 1. 타이틀 영역
  fill(40, 50, 70);
  textSize(24);
  text("📥 Infix to Postfix Interactive Calculator", 40, 50);
  
  // 안내 가이드
  textSize(13);
  fill(100, 110, 120);
  text("⚠️ 두 자리 이상 숫자를 처리하기 위해 원소 사이에 반드시 '공백(Space)'을 넣어주세요! (예: 10 + 5)", 40, 80);
  text("⌨️ 키보드로 직접 수식을 타이핑하세요. [Backspace]로 지우고, [Enter]를 누르면 계산됩니다.", 40, 100);
  
  // 2. 사용자 입력 상자 UI
  textSize(16);
  fill(255);
  stroke(200);
  strokeWeight(2);
  rect(40, 120, 620, 45, 8); // 입력창 박스
  
  fill(30);
  // 커서 깜빡임 효과 (0.5초 주기로 커서 '|' 표시)
  String cursor = (frameCount / 30 % 2 == 0) ? "|" : "";
  text(userInput + cursor, 55, 148);
  
  // 3. 변환 및 계산 결과창 영역
  // 후위 표기법 결과
  fill(255);
  rect(40, 200, 620, 80, 8);
  fill(120);
  textSize(12);
  text("POSTFIX EXPRESSION (후위 표기법 변환 결과)", 55, 222);
  fill(0, 102, 204);
  textSize(20);
  text(postfixResult, 55, 255);
  
  // 최종 계산 결과
  fill(255);
  rect(40, 300, 620, 80, 8);
  fill(120);
  textSize(12);
  text("CALCULATION RESULT (최종 연산 결과)", 55, 322);
  
  if (!errorMessage.equals("")) {
    fill(220, 50, 50); // 에러 발생 시 빨간색 표시
    textSize(18);
    text(errorMessage, 55, 355);
  } else {
    fill(40, 160, 80); // 정상 연산 시 초록색 표시
    textSize(24);
    text(calculationResult, 55, 357);
  }
}

// 사용자가 키보드를 누를 때마다 실행되는 이벤트 함수
public void keyPressed() {
  // 엔터 키를 누르면 수식 검증 및 계산 수행
  if (key == ENTER || key == RETURN) {
    processExpression(userInput);
  } 
  // 백스페이스 키를 누르면 글자 지우기
  else if (key == BACKSPACE) {
    if (userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
  } 
  // 일반 글자 입력 (Processing 특수키 무시 및 수식에 필요한 문자 필터링)
  else if (key != CODED && key != ESC && key != TAB) {
    userInput += key;
  }
}

// 전체 입력 문자열을 받아 후위표기 변환 및 스택 계산 프로세스 실행
void processExpression(String input) {
  // 수식이 완전히 비어있는 경우 예외 처리
  if (input.trim().isEmpty()) {
    postfixResult = "";
    calculationResult = "";
    errorMessage = "수식을 입력해주세요.";
    return;
  }
  
  try {
    errorMessage = ""; // 에러 초기화
    postfixResult = infixToPostfix(input);
    float val = evaluatePostfix(postfixResult);
    
    // 소수점 아래가 0이면 정수로, 아니면 실수 그대로 표기 정제
    if (val == (int) val) {
      calculationResult = String.valueOf((int) val);
    } else {
      calculationResult = String.valueOf(val);
    }
  } catch (Exception e) {
    postfixResult = "Error";
    calculationResult = "";
    errorMessage = "잘못된 수식 형식입니다. (괄호 매칭 또는 공백을 확인하세요)";
  }
}

// 연산자 우선순위 리턴
int getPrecedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return -1;
}

// [스택 활용 1단계] 중위 -> 후위 변환
String infixToPostfix(String infix) {
  StringBuilder output = new StringBuilder();
  Stack<String> stack = new Stack<String>();
  
  String[] tokens = infix.trim().split("\\s+");
  
  for (String token : tokens) {
    if (token.isEmpty()) continue;
    
    // 피연산자 (음수 포함 숫자 패턴 매칭)
    if (token.matches("-?\\d+(\\.\\d+)?")) { 
      output.append(token).append(" ");
    } 
    else if (token.equals("(")) {
      stack.push(token);
    } 
    else if (token.equals(")")) {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.append(stack.pop()).append(" ");
      }
      if (stack.isEmpty()) throw new IllegalArgumentException("괄호 불일치");
      stack.pop(); 
    } 
    else if (token.equals("+") || token.equals("-") || token.equals("*") || token.equals("/")) { 
      while (!stack.isEmpty() && getPrecedence(stack.peek()) >= getPrecedence(token)) {
        output.append(stack.pop()).append(" ");
      }
      stack.push(token);
    } else {
      throw new IllegalArgumentException("허용되지 않은 문자");
    }
  }
  
  while (!stack.isEmpty()) {
    String top = stack.pop();
    if (top.equals("(")) throw new IllegalArgumentException("괄호 불일치");
    output.append(top).append(" ");
  }
  
  return output.toString().trim();
}

// [스택 활용 2단계] 후위 표기법 계산
float evaluatePostfix(String postfix) {
  if (postfix.equals("Error") || postfix.isEmpty()) return 0;
  
  Stack<Float> stack = new Stack<Float>();
  String[] tokens = postfix.split("\\s+");
  
  for (String token : tokens) {
    if (token.isEmpty()) continue;
    
    if (token.matches("-?\\d+(\\.\\d+)?")) {
      stack.push(Float.parseFloat(token));
    } 
    else {
      if (stack.size() < 2) throw new IllegalArgumentException("피연산자 부족");
      float num2 = stack.pop(); 
      float num1 = stack.pop(); 
      
      switch (token) {
        case "+": stack.push(num1 + num2); break;
        case "-": stack.push(num1 - num2); break;
        case "*": stack.push(num1 * num2); break;
        case "/": 
          if (num2 == 0) throw new ArithmeticException("0으로 나눌 수 없음");
          stack.push(num1 / num2); 
          break;
      }
    }
  }
  if (stack.size() != 1) throw new IllegalArgumentException("연산자 부족");
  return stack.pop();
}
