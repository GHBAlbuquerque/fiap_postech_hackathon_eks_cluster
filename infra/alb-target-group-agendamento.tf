# target group node port 30008 - MS AGENDAMENTO
resource "aws_lb_target_group" "target-group-ms-agendamento" {
  name        = "target-group-ms-agendamento"
  port        = 30008
  target_type = "instance"
  protocol    = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    path     = "/actuator/health"
    port     = 30008
    matcher  = "200"
    interval = 90
    timeout  = 60
  }
}

resource "aws_lb_target_group_attachment" "attach-ms-agendamento" {
  target_group_arn = aws_lb_target_group.target-group-ms-agendamento.arn
  target_id        = data.aws_instance.ec2.id
  port             = 30008
}

resource "aws_lb_listener_rule" "listener-rule-ms-agendamento" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 500

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-ms-agendamento.arn
  }

  condition {
    http_header {
      http_header_name = "microsservice"
      values           = ["ms_agendamento"]
    }
  }
}