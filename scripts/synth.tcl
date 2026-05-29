# ============================================================
# Script de Síntese - SAED32_EDK
# Suporte a SystemVerilog (.sv)
# ============================================================

# 1. CARREGAR CONFIGURAÇÃO
source ./scripts/.synopsys_dc.setup

# 2. LEAR O ARQUIVO RTL (SYSTEMVERILOG)
# Substitua 'meu_design.sv' pelo nome do seu arquivo SystemVerilog
analyze -format sverilog ./rtl/porta_and.sv

# 3. ELABORAR O DESIGN
# Substitua 'meu_design_top' pelo nome do módulo top do seu design
elaborate porta_and

# 4. CARREGAR CONSTRAINTS
read_sdc scripts/constraints.sdc

# 5. ANTES DA SÍNTESE - RELATÓRIOS INICIAIS
puts "\n============================================================"
puts "RELATÓRIOS PRÉ-SÍNTESE"
puts "============================================================"
report_area -hierarchy > area_pre.rpt
report_timing -max_paths 10 > timing_pre.rpt

# 6. SÍNTESE (compile_ultra é mais agressivo que compile)
puts "\n============================================================"
puts "INICIANDO SÍNTESE (SystemVerilog)..."
puts "============================================================"
compile_ultra

# 7. RELATÓRIOS PÓS-SÍNTESE
puts "\n============================================================"
puts "RELATÓRIOS PÓS-SÍNTESE"
puts "============================================================"

# Relatório de área
report_area -hierarchy > area_pos.rpt
puts "\n[Área] Relatório salvo em: area_pos.rpt"

# Relatório de timing (setup)
report_timing -max_paths 10 > timing_relatorio.rpt
puts "[Timing] Relatório salvo em: timing_relatorio.rpt"

# Relatório de power
report_power > power.rpt
puts "[Power] Relatório salvo em: power.rpt"

# Relatório de violações de setup
report_constraint -all_violators -check_type setup > setup_violations.rpt
puts "[Setup Violations] Relatório salvo em: setup_violations.rpt"

# Relatório de violações de hold
report_constraint -all_violators -check_type hold > hold_violations.rpt
puts "[Hold Violations] Relatório salvo em: hold_violations.rpt"

# 8. EXPORTAR NETLIST
# Formato Verilog (para simulação)
write -format verilog -hierarchy -output meu_design_syn.sv
puts "\n[Netlist] SystemVerilog salvo em: meu_design_syn.sv"

# Formato DDC (binário Synopsys, mais rápido para ICC2)
write -format ddc -hierarchy -output meu_design_syn.ddc
puts "[Netlist] DDC salvo em: meu_design_syn.ddc"

# 9. SALVAR DESIGN EM MEMORY
save_designs -force meu_design.db
puts "[Design] Salvado em: meu_design.db"

# 10. FINALIZAR
puts "\n============================================================"
puts "SÍNTESE CONCLUÍDA COM SUCESSO (SystemVerilog)!"
puts "============================================================"
puts "Arquivos gerados:"
puts "  - meu_design_syn.sv (netlist SystemVerilog)"
puts "  - meu_design_syn.ddc (netlist DDC)"
puts "  - area_pos.rpt (área)"
puts "  - timing_relatorio.rpt (timing)"
puts "  - power.rpt (potência)"
puts "============================================================"