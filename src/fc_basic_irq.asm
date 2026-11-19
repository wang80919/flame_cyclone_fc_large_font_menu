;IRQ(请求中断)处理
Irq_Program_Process
    PHA
    TXA
    PHA
    TYA
    PHA
    STA $E000;禁用 & 确认IRQ
    LDX FC_Irq_Index
    LDA FC_Irq_Interval_L,X;设置下次IRQ扫描线
    STA $C000
    STA $C001
    LDY #12
.Wait;延迟等待, 将CHR切换放到水平消隐
    DEY
    BNE .Wait
    LDA FC_Chr_Index_Ready,X;CHR切换就绪?
    BNE .Chr_Cur
    LDA #$82
    LDY FC_Chr_Index_Last,X;保持旧的CHR
    STA $8000
    STY $8001
    JMP .Next_Irq
.Chr_Cur;更新为当前CHR
    LDA #$82
    LDY FC_Chr_Index,X
    STA $8000
    STY $8001
.Next_Irq
    INC FC_Irq_Index
    DEC FC_Irq_Count;检查剩余IRQ数量
    BEQ .Irq_Process_End
.Irq_Enable
    STA $E001;启用IRQ
.Irq_Process_End
    LDA FC_Prg_Mode;恢复切页模式
    STA $8000
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI
