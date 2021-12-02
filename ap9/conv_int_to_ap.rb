#!/usr/bin/ruby
class LiteralAND
    BIT_ZERO = 0
    BIT_ONE = 1
    BIT_NONE = 10
    AP = 9

    attr_accessor :bits
    attr_accessor :marked
    attr_accessor :merged

    def initialize(init_num)
        @marked = false
        @merged = false
        @bits = [] #LSB[0 <- 0-th bit, 1 <- 1-th bit, 1] = 3
        for i in 1..AP do
            if(init_num & 0x1 == 0x1) then
                @bits.append(BIT_ONE)
            else
                @bits.append(BIT_ZERO)
            end
            init_num = init_num >> 1
        end
    end

    def to_s
        str = ""
        if @marked then
            str = "*"
        end
        for b in @bits do
            if b == BIT_ZERO then
                str += "0"
            elsif b == BIT_ONE then
                str += "1"
            elsif b == BIT_NONE then
                str += "-"
            end
        end

        return str.reverse 
    end

    def to_ap_s
        str = ""
        for i in 0..LiteralAND::AP-1 do
            b = @bits[i]
            if b == BIT_ZERO then
                str += sprintf("!p%d&", i) 
            elsif b == BIT_ONE then
                str += sprintf("p%d&", i) 
            end
        end

        return str.slice(0..str.length-2)
    end

    def hamming(opr)
        cnt = 0
        for i in 0..AP-1 do
            bit_my = @bits[i]
            bit_opr = opr.bits[i]
            if bit_my != bit_opr then
                cnt += 1
            end
        end

        return cnt
    end

    def merge(opr)
        @merged = true
        opr.merged = true
        new_lit = LiteralAND.new(0)
        for i in 0..AP-1 do
            bit_my = @bits[i]
            bit_opr = opr.bits[i]
            if bit_my != bit_opr then
                new_lit.bits[i] = BIT_NONE
            else
                new_lit.bits[i] = bit_my
            end
        end

        return new_lit
    end

    def pop_cnt
        cnt = 0
        for b in @bits do
            if b == BIT_ONE then
                cnt += 1
            end
        end
        return cnt
    end

    def is_satisfy(lit)
        for i in 0..AP-1 do
            bit_my = @bits[i]
            bit_lit = lit.bits[i]
            if bit_lit == BIT_NONE then
            elsif bit_lit != bit_my then
                return false
            end
        end

        return true
    end
end

# TODO: this method does not consider 'don't care'
def quine_mcluskey(lit_arr)
    table = qm_new_table()
    for lit in lit_arr do
        table[lit.pop_cnt][lit.to_s] = lit
    end

    finish = false
    while !finish do
        new_table = qm_new_table()

        #print_qm_table(table)
        for i in 0..LiteralAND::AP-1 do
            table[i].each_value do |lit_small|
                table[i+1].each_value do |lit_large|
                    if lit_small.hamming(lit_large) == 1 then
                        new_lit = lit_small.merge(lit_large)
                        new_table[new_lit.pop_cnt][new_lit.to_s] = new_lit
                    end
                end
                if !lit_small.merged then
                    lit_small.marked = true
                    new_table[lit_small.pop_cnt][lit_small.to_s] = lit_small
                end
            end
        end

        table = new_table
        finish = true
        for i in 0..LiteralAND::AP do
            table[i].each_value do |lit|
                if !lit.marked then
                    finish = false
                end
            end
        end
        #print("\n")
    end
    #print_qm_table(table)

    ret = []
    for i in 0..LiteralAND::AP do
        table[i].each_value do |lit|
            ret.append(lit)
        end
    end

    return ret
end

def qm_new_table
    table = []
    for i in 0..LiteralAND::AP do
        table[i] = Hash.new()
    end

    return table
end

def print_qm_table(table)
    for i in 0..LiteralAND::AP do
        s = sprintf("%d | ", i)
        table[i].each_value do |lit|
            s += lit.to_s + ", "
        end
        s += "\n"
        print(s)
    end
end

def gen_formula(min, max)
    arr = []
    for i in min..max do
        arr.append(LiteralAND.new(i))
    end
    ret = quine_mcluskey(arr)

    return ret
end

def conv_int_to_ap(min, max)
    ret = gen_formula(min, max)
    formula = ""
    for lit in ret do
        formula += sprintf("(%s)|", lit.to_ap_s)
    end

    return formula.slice(0..formula.length-2)
end

def get_result(input, lit_arr)
    for lit in lit_arr do
        if input.is_satisfy(lit) then
            return true
        end
    end

    return false
end


def test()
    test1 = gen_formula(70, 511)
    for i in (0..69) do
        input = LiteralAND.new(i)
        res = get_result(input, test1) 
        if res then
            p sprintf("input=%d expected:%s actual:%s", i, false, res)
        end
    end
    for i in (70..511) do
        input = LiteralAND.new(i)
        res = get_result(input, test1) 
        if !res then
            p sprintf("input=%d expected:%s actual:%s", i, true, res)
        end
    end
    print("PASSED!\n")
end

#test()
raise "Usage: #{$0} min max" unless ARGV.size == 2
print(conv_int_to_ap(ARGV[0].to_i, ARGV[1].to_i) +"\n")

