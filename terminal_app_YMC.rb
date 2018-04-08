require 'io/console'
require 'launchy'
require 'command_line_reporter'
require 'tty-prompt'
require 'bar-of-progress'

system('clear')

class Game
    include CommandLineReporter
    @@day = 0
    @@status = ["Total Noob", "Command line Guru", "Git Pro", "Ruby Sensei", "HTML/CSS Ace", "Rails Ninja", "Javascript Master", "Job ready!"]
    @@next_level = [150, 330, 550, 810, 1120, 1490, 1700]
    @@bar = BarOfProgress.new(:total => 100,
                              :length => 87,
                              :braces => %w{},
                              :complete_indicator => "■".cyan,
                              :partial_indicator => "▤".cyan,
                              :incomplete_indicator => "□".blue,
                              :precision => 20)
    def initialize
    end 
    
    def flash(text,count)
        count.times do
            print "\r#{ text }"
            sleep 0.5
            print "\r#{ ' ' * text.size }"
            sleep 0.5
        end 
    end  

    def run_text(text,speed,delay)
        text.each_char {|c| putc c; sleep(speed)}
        sleep(delay)
    end

    def clear_lines(number)
        number.times do |item|
            print "\r" + "\e[A\e[J" if item > 0
        end
    end

    def new_game_intro
        puts `clear`
        run_text("> Welcome, new player!\n",0.03,1.5)
        run_text("> Please enter your name (or enter 'b' to go back): ",0.03,1)
        @new_player = gets.chomp.capitalize
        if @new_player == 'B'
            system('clear')
            start_new_game
        end
        puts `clear`
        run_text("> Hello, #{@new_player}!\n",0.03,0)
        flash(" ...",2)
        puts "\n"
        run_text("> Welcome to Mellow Yellow Coder!\n",0.03,0)
        flash(" ...",2)
        puts "\n"
        run_text("> You are new to the world of programming and you have multiple stages to go through before you can officially become a Coding Beast. \n",0.03,0) 
        flash(" ...",2)
        puts "\n"
        run_text("> Your goal is to become a proficient programmer and get a job in a tech corporation!\n",0.03,0)
        flash(" ...",2)
        puts "\n"
        run_text("> Good luck!!!\n",0.03,0)
        flash(" ...",2)
        puts `clear`
    end

    def multiplier_tracker
        if @burnout_total >= 90 && @burnout_total <= 100
            @multiplier = 0.25
            @burnout_string = @burnout_string.red
        elsif @burnout_total >= 70 && @burnout_total < 90
            @multiplier = 0.5
            @burnout_string = @burnout_string.magenta
        elsif @burnout_total >= 20 && @burnout_total < 70
            @multiplier = 1
            @burnout_string = @burnout_string.yellow
        elsif @burnout_total >= 0 && @burnout_total < 20
            @multiplier = 2
            @burnout_string = @burnout_string.blue
        end
    end

    def living_conditions_checker
        if @living_condition == "a broke student"
            @expense_per_day = 15
            @burnout_life_per_day = 5
        elsif @living_condition == "healthy food"
            @expense_per_day = 35
            @burnout_life_per_day = 1
        elsif @living_condition == "comfortable living"
            @expense_per_day = 60
            @burnout_life_per_day = -6
        elsif @living_condition == "live like a superstar"
            @expense_per_day = 200
            @burnout_life_per_day = -25
        end
    end

    def job_checker
        if @job == "work in retail"
            @income_per_day = 16
            @burnout_work_per_day = 5
        elsif @job == "movie set extra"
            @income_per_day = 30
            @burnout_work_per_day = 10
        elsif @job == "pet shop manager"
            @income_per_day = 50
            @burnout_work_per_day = 16
        elsif @job == "part-time accountant"
            @income_per_day = 150
            @burnout_work_per_day = 40
        elsif @job == "webdev freelancer"
            @income_per_day = rand(30..100)
            @burnout_work_per_day = rand(10..30)
        end
    end
    
    def level_tracker
        if @skill_total < 150
            @level = 0
        elsif @skill_total >= 150 && @skill_total < 330
            @level = 1
        elsif @skill_total >= 330 && @skill_total < 550
            @level = 2
        elsif @skill_total >= 550 && @skill_total < 810
            @level = 3
        elsif @skill_total >= 810 && @skill_total < 1120
            @level = 4
        elsif @skill_total >= 1120 && @skill_total < 1490
            @level = 5
        elsif @skill_total >= 1490 && @skill_total < 1700
            @level = 6
        else
            @level = 7
        end
    end
    
    def entertainment_menu
        puts "\n\s [1] Organise a house LAN party (costs $10)"
        puts "\s [2] Spend a day at the VR center (costs $40)"
        puts "\s [3] Visit the San Diego ComicCon (costs $150, takes 2 days)"
        puts "\s [0] Go back"
        loop do
            event_choice = STDIN.getch
            if event_choice == '1'
                @activity = "LAN party"
                flash("  ...",2)
                clear_lines(8)
                actions_menu
            elsif event_choice == '2'
                @activity = "VR centre"
                flash("  ...",2)
                clear_lines(8)
                actions_menu
            elsif event_choice == '3'
                @activity = "SD ComicCon"
                flash("  ...",2)
                clear_lines(8)
                actions_menu
            elsif event_choice == '0'
                clear_lines(8)
                puts "\n\s> Choose your activity for today [chose #{@activity.green}]: "
                activity_menu
            end
        end
    end
    
    def help
        puts "\n\s1. Start the day by selecting your " + "expense level".yellow + ", " + "current job".cyan + " (if you are planning to\n\s\s\s\sgo to work) and a planned " + "activity".green
        puts "\s2. Once you are set with your decisions, choose the option 'I am done for today!' to\n\s\s\s\smove on to the next day"
        puts "\s3. If you do not make any changes to your decisions, the day will continue the same way\n\s\s\s\sas the previous day"
        puts "\s4. Each activity will have an impact on at least 2 of your stats:\n\s\s\s\smoney[$$$], burnout[B0] or coding skill[CS]"
        puts "\s5. By default, you can earn 12 Coding Skill points per day (provided you chose to code).\n\s\s\s\sHowever, your burnout level will determine how productive you can be:\n\n\s\s\s\s\sif the burnout is less than 20%, your multiplier will be 2x (i.e. 24 CS points),\n\s\s\s\s\sif burnout is from 20%-70%, you earn 12 CS points at 1x multiplier\n\s\s\s\s\sburnout level of 70%-90% will result in 0.5 multiplier (6 CS points)\n\s\s\s\s\sand burnout > 90% will only give you 0.25x multiplier (3 CS points)"
        puts "\n\s6. Your goal is to reach the 'job ready' coding skill level without burning out"
        puts "\s7. Once you go into bank account overdraft, your only available option will be to go to work"
        puts "\s8. Your burnout level will also determine which activities you can undertake"
        puts "\s9. " + "Paid entertainment".underline + " is a faster way to decrease your burnout, but they come at a price.\n\s\s\s\sAnother option would be to use the 'Day off' to reduce your burnout without any cost"
        puts "\s10. Once unlocked, you can participate in " + "hackathons".underline + " to greatly increase your coding skills.\n\s\s\s\sThe participation has a fixed entry cost ($100), however the burnout from participation\n\s\s\s\sand the coding skill gains are random (but not the multiplier)"
        puts "\s11. The game will end if your burnout is at 100% and you do not have means to\n\s\s\s\ssurvive another day"
        puts "\n\t\t\t\t(press Space to continue)"
        loop do
            cont = STDIN.getch
            if cont == "\s"
                clear_lines(30) 
                actions_menu
            end
        end
    end
    
    def quit_game
        quit_game_loop = true
        while quit_game_loop
            print "\n\s> Are you sure you want to quit? [y/n]: "
            answer = gets.chomp.downcase
            if answer == 'y'
                clear_lines(1)
                run_text("\n\s> Thanks for playing!\n",0.03,0)
                flash(" ...",3)
                system('clear')
                exit
            elsif answer == 'n'
                quit_game_loop = false
                clear_lines(10)
                actions_menu
            else
                clear_lines(3)
            end
        end
    end

    def day_1_stats
        if @@day == 1
            @money = 215
            @burnout_total = 0
            @skill_total = 0
            @job = "none"
            @activity = "none"
            @living_condition = "a broke student"
            @burnout_string = " #{@burnout_total.round(2)}%"
            multiplier_tracker  
        end
    end

    def day_calc
        @skill_for_day = 0
        @burnout_life_per_day = 0.0
        @burnout_work_per_day = 0.0
        @burnout_code_per_day = 0.0
        @income_per_day = 0.0
        @expense_per_day = 0.0
        @activity_cost = 0.0
        if @activity == "coding the whole day"
            @skill_for_day = 12 * @multiplier
            @burnout_code_per_day = 7
        elsif @activity == "part-time job"
            job_checker
        elsif @activity == "participation in a hackathon"
            @skill_for_day = rand(10..80) * @multiplier
            @activity_cost = 100
            @burnout_code_per_day = rand(7..20)
        elsif @activity == "LAN party"
            @activity_cost = 10
            @burnout_code_per_day = -5
        elsif @activity == "VR centre"
            @activity_cost = 40
            @burnout_code_per_day = -25
        elsif @activity == "SD ComicCon"
            @activity_cost = 150
            @burnout_code_per_day = -90
            @@day += 1
        elsif @activity == "a day off"
            @burnout_code_per_day = -12
        end
        living_conditions_checker
        @money += @income_per_day - @expense_per_day - @activity_cost
        @burnout_total += @burnout_life_per_day + @burnout_work_per_day + @burnout_code_per_day
        @burnout_total = @burnout_total.clamp(0, 100)
        @skill_total += @skill_for_day
        @burnout_string = " #{@burnout_total.round(2)}%"
        multiplier_tracker
    end

    def day_output
        @@day += 1
        day_1_stats
        level_tracker
        table(border: true) do
            row do
                column("Day #{@@day}", width: 40)
                column("Current knowledge: #{@@status[@level]}", width: 40, align: 'right')
            end
            row do
                column("Bank account [$$$]: $#{@money}")
                column("Coding skill [CS]: #{@skill_total.to_i}/#{@@next_level[@level]}")
            end
        end
        puts "\s\sBurnout bar [BO]:" + @burnout_string
        puts @@bar.progress(@burnout_total)
        puts "\n"
        puts "\s\sYesterday's activity: #{@activity.green}"
        puts "\s\sYesterday's expense level: #{@living_condition.yellow}"
        puts "\s\sMost recent job: #{@job.cyan}"
        puts "\s\sCurrent multiplier: #{@multiplier}x"
        puts "======================================================================================="
    end

    def game_checks
        if @burnout_total == 100 && (@activity == "coding the whole day" || @activity == "part-time job" || @activity == "participation in a hackathon")
            puts "\n\s" + "You are too burnt out!".white_on_red
            flash(" ...",2)
            clear_lines(3)   
        elsif @money < 0 && @activity != "part-time job"
            puts "\n\s" + "You don't have enough money to go through this day!".white_on_red
            flash(" ...",2)
            clear_lines(3)
        else
            clear_lines(8)
            puts "\n\s> You sure you are done for today? [press 'space' to confirm or 'b' to go back]"
            n = 3
            if @activity == "none"
                puts "\s  (You haven't chosen any activity for today)"
                n = 4
            end
            loop do
                confirm = STDIN.getch
                if confirm == "\s"
                    clear_lines(n)
                    day_calc
                    if @skill_total >= 1700
                        puts "\n\sCongrats! Your hard work paid off. You are now a full-stack developer!" #end game msg
                        puts "\sIt took you...#{@@day+1} days!"
                        loop do
                            key_press = STDIN.getch
                            if key_press == "\s"
                                system('clear')
                                exit
                            end
                        end
                    else
                        day_report
                    end
                elsif confirm == 'b'
                    clear_lines(n)
                    actions_menu
                end
            end
        end
    end
    
    def day_report        
        puts "\n\sDay #{@@day} report:"
        puts "\tyou spent " + "$#{@expense_per_day + @activity_cost}".red
        puts "\tyou earned " + "$#{@income_per_day}".green
        puts "\tyou gained #{@skill_for_day.to_i} coding skill points"
        burnout_rate = @burnout_life_per_day + @burnout_work_per_day + @burnout_code_per_day
        if burnout_rate >= 0
            verb = "increased"
            bo_str = (verb + " by #{burnout_rate.abs}%").red
        else
            verb = "decreased"
            bo_str = (verb + " by #{burnout_rate.abs}%").green
        end
        puts "\tyour burnout " + bo_str
        if @money < 15
            puts "\t" + "WARNING: Your funds are getting low. You better go to work tomorrow!".white_on_red
        end
        puts "\n\t\t\t\t(press Space to continue)"
        loop do
            cont = STDIN.getch
            if cont == "\s"
                if @money < 15   
                    clear_lines(10) 
                else
                    clear_lines(9) 
                end
                puts "\n\s> On to the next day then!"
                flash(" ...",2)
                puts `clear`
                day_output
                actions_menu
            end
        end
    end

    def actions_menu
        puts "\n\s[1] Choose your activity for today [current choice: #{@activity.green}]"
        puts "\s[2] Change your current expense level [current choice: #{@living_condition.yellow}]"
        puts "\s[3] Change your current side job [current choice: #{@job.cyan}]"
        puts "\s[4] I am done for today!"
        puts "\s[5] Help"
        puts "\s[0] Quit game"
        loop do
            action_choice = STDIN.getch
            if action_choice == '1'
                clear_lines(8)
                puts "\n\s> Choose your activity for today [current choice: #{@activity.green}]: "
                activity_menu
            elsif action_choice == '2'
                clear_lines(8)
                puts "\n\s> Change your expense level [current choice: #{@living_condition.yellow}]: "
                expense_menu
            elsif action_choice == '3'
                clear_lines(8)
                puts "\n\s> Change your current side job [current choice: #{@job.cyan}]: "
                puts "\t(don't forget to change your current activity)"
                jobs_menu
            elsif action_choice == '4'
                game_checks
            elsif action_choice == '5'
                clear_lines(8)
                help
            elsif action_choice == '0'
                quit_game
            end
        end
    end

    def activity_menu
        puts "\n\s[1] Learn to code! -> " + "+BO ".red + "+CS".green
        puts "\s[2] Go to work -> " + "+BO ".red + "+$$$".green
        puts "\s[3] Participate in a hackathon (requirements: at least " + "Ruby".white_on_red + " knowledge and " + "$100".white_on_red + ")-> " + "+BO ".red + "+CS ".green + "-$$$".red
        puts "\s[4] Paid entertainment = best entertainment! -> " + "-BO ".green + "-$$$".red
        puts "\s[5] Take a day off! -> " + "-BO".green
        puts "\s[0] Go back"
        loop do
            activity_choice = STDIN.getch
            if activity_choice == '1'
                run_text("\n\s" + "Well done! You have decided to spend the day coding!\n".black_on_green,0.03,0)
                @activity = "coding the whole day"
                flash(" ...",2)
                clear_lines(12)
                actions_menu
            elsif activity_choice == '2'
                if @job == "none"
                    puts "\n\s" + "Please select a job first!".white_on_red
                    flash(" ...",2)
                    clear_lines(12)
                    actions_menu
                else
                    run_text("\n\s" + "Going to work it is!\n".black_on_green,0.03,0)
                    @activity = "part-time job"
                    flash(" ...",2)
                    clear_lines(12)
                    actions_menu
                end
            elsif activity_choice == '3'
                if @skill_total >= 550 && @money >= 100
                    run_text("\n\s" + "Hackathon time!\n".black_on_green,0.03,0)
                    @activity = "participation in a hackathon"
                    flash(" ...",2)
                    clear_lines(12)
                    actions_menu
                else
                    puts "\n\s" + "You don't have enough experience and/or money to participate!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif activity_choice == '4'
                clear_lines(10)
                puts "\n\s[4] Paid entertainment = best entertainment!: "
                entertainment_menu
            elsif activity_choice == '5'
                run_text("\n\s" + "Chill mode on\n".black_on_green,0.03,0)
                @activity = "a day off"
                flash(" ...",2)
                clear_lines(12)
                actions_menu
            elsif activity_choice == '0'
                clear_lines(10)
                actions_menu
            end
        end
    end

    def expense_menu
        puts "\n\s[1] A broke student -> " + "(low daily expense, slight burnout cost)".white_on_black
        puts "\s[2] Trying to eat healthy -> " + "(medium daily expense, almost no impact on burnout)".white_on_black
        puts "\s[3] I don't want to think about my expenses -> " + "(high daily expense, decreases burnout)".white_on_black
        puts "\s[4] Playa! Live like there is no tomorrow! -> " + "(can you afford it though?)".white_on_black
        puts "\s[0] Go back"
        loop do
            expense_choice = STDIN.getch
            if expense_choice == '1'
                run_text("\n\s" + "Better start saving on those pennies!\n".black_on_yellow,0.03,0)
                @living_condition = "a broke student"
                flash(" ...",2)
                clear_lines(11)
                actions_menu
            elsif expense_choice == '2'
                run_text("\n\s" + "Gotta do something about that coder lifestyle\n".black_on_yellow,0.03,0)
                @living_condition = "healthy food"
                flash(" ...",2)
                clear_lines(11)
                actions_menu
            elsif expense_choice == '3'
                run_text("\n\s" + "Who cares about savings?\n".black_on_yellow,0.03,0)
                @living_condition = "comfortable living"
                flash(" ...",2)
                clear_lines(11)
                actions_menu
            elsif expense_choice == '4'
                run_text("\n\s" + "Well, you better know what you are doing\n".black_on_yellow,0.03,0)
                @living_condition = "live like a superstar"
                flash(" ...",2)
                clear_lines(11)
                actions_menu
            elsif expense_choice == '0'
                clear_lines(9)
                actions_menu
            end
        end
    end

    def jobs_menu
        puts "\n\s[1] Work in retail -> " + "($16/day - low burnout)".white_on_black
        puts "\s[2] Movie set extra -> " + "($30/day - medium burnout)".white_on_black
        puts "\s[3] Pet shop manager -> " + "($50/day - high burnout)".white_on_black
        puts "\s[4] Accountant -> " + "(might as well sell your soul for money)".white_on_black
        puts "\s[5] Webdev freelancing -> " + "($30-$100/day - burnout varies)".white_on_black
        puts "\s[0] Go back"
        loop do
            job_choice = STDIN.getch
            if job_choice == '1'
                if @burnout_total <= 95
                    run_text("\n\s" + "You started working in retail!\n".black_on_cyan,0.03,0)
                    @job = "work in retail"
                    flash(" ...",2)
                    clear_lines(13)
                    actions_menu
                else
                    puts "\n\s" + "You are too burnt out for this job!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif job_choice == '2'
                if @burnout_total <= 90
                    run_text("\n\s" + "You started working as a movie set extra!\n".black_on_cyan,0.03,0)
                    @job = "movie set extra"
                    flash(" ...",2)
                    clear_lines(13)
                    actions_menu
                else
                    puts "\n\s" + "You are too burnt out for this job!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif job_choice == '3'
                if @burnout_total <= 84
                    run_text("\n\s" + "You started working as a pet shop manager!\n".black_on_cyan,0.03,0)
                    @job = "pet shop manager"
                    flash(" ...",2)
                    clear_lines(13)
                    actions_menu
                else
                    puts "\n\s" + "You are too burnt out for this job!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif job_choice == '4'
                if @burnout_total <= 60
                    run_text("\n\s" + "You started working as a part-time accountant!\n".black_on_cyan,0.03,0)
                    @job = "part-time accountant"
                    flash(" ...",2)
                    clear_lines(13)
                    actions_menu
                else
                    puts "\n\s" + "You are too burnt out for this job!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif job_choice == '5'
                if @skill_total >= 810
                    if @burnout_total <= 90
                        run_text("\n\s" + "You started working as a webdev freelancer!\n".black_on_cyan,0.03,0)
                        @job = "webdev freelancer"
                        flash(" ...",2)
                        clear_lines(13)
                        actions_menu
                    else
                        puts "\n\s" + "You are too burnt out for this job!".white_on_red
                        flash(" ...",2)
                        clear_lines(3)
                    end
                else
                    puts "\n\s" + "You are not ready for this job! Get more coding exp!".white_on_red
                    flash(" ...",2)
                    clear_lines(3)
                end
            elsif job_choice == '0'
                clear_lines(11)
                actions_menu
            end
        end
    end
end

class StartMenu
    def initialize
        lines("========================================================================================================".yellow)
        lines("========================================================================================================".yellow)
        lines("  __      __        __ __                              __       __          __ __                              ".yellow)
        lines(" |  \\    /  \\      |  |  \\                            |  \\     /  \\        |  |  \\                          ".yellow)
        lines("  \\$$\\  /  $______ | $| $$ ______  __   __   __       | $$\\   /  $$ ______ | $| $$ ______  __   __   __       ".yellow)
        lines("   \\$$\\/  $/      \\| $| $$/      \\|  \\ |  \\ |  \\      | $$$\\ /  $$$/      \\| $| $$/      \\|  \\ |  \\ |  \\ ".yellow)
        lines("    \\$$  $|  $$$$$$| $| $|  $$$$$$| $$ | $$ | $$      | $$$$\\  $$$|  $$$$$$| $| $|  $$$$$$| $$ | $$ | $$      ".yellow)
        lines("     \\$$$$| $$    $| $| $| $$  | $| $$ | $$ | $$      | $$\\$$ $$ $| $$    $| $| $| $$  | $| $$ | $$ | $$      ".yellow)
        lines("     | $$ | $$$$$$$| $| $| $$__/ $| $$_/ $$_/ $$      | $$ \\$$$| $| $$$$$$$| $| $| $$__/ $| $$_/ $$_/ $$      ".yellow)
        lines("     | $$  \\$$     | $| $$\\$$    $$\\$$   $$   $$      | $$  \\$ | $$\\$$     | $| $$\\$$    $$\\$$   $$   $$    ".yellow)
        lines("      \\$$   \\$$$$$$$\\$$\\$$ \\$$$$$$  \\$$$$$\\$$$$        \\$$      \\$$ \\$$$$$$$\\$$\\$$ \\$$$$$$  \\$$$$$\\$$$$".yellow)
        lines("                                  ______                 __                                             ".yellow)
        lines("                                 /      \\               |  \\                                            ".yellow)
        lines("                                |  $$$$$$\\ ______   ____| $$ ______   ______                            ".yellow)
        lines("                                | $$   \\$$/      \\ /      $$/      \\ /      \\                           ".yellow)
        lines("                                | $$     |  $$$$$$|  $$$$$$|  $$$$$$|  $$$$$$\\                          ".yellow)
        lines("                                | $$   __| $$  | $| $$  | $| $$    $| $$   \\$$                          ".yellow)
        lines("                                | $$__/  | $$__/ $| $$__| $| $$$$$$$| $$                                ".yellow)
        lines("                                 \\$$    $$\\$$    $$\\$$    $$\\$$     | $$                                ".yellow)
        lines("                                  \\$$$$$$  \\$$$$$$  \\$$$$$$$ \\$$$$$$$\\$$                                ".yellow)
        lines("========================================================================================================".yellow)
        lines("========================================================================================================".yellow)
    end

    def lines(text)
        puts text
        sleep(0.06)
    end

    def main_menu
        prompt = TTY::Prompt.new
        choice = prompt.select('',marker: '', help: '') do |menu|
            menu.choice 'New Game'.center(100), 1
            menu.choice 'Continue (not available)'.center(100), 2, disabled: ''
            menu.choice 'Score Board (not available)'.center(100), 3, disabled: ''
            menu.choice 'Exit'.center(100), 4
        end
        if choice == 1
            game = Game.new
            game.new_game_intro
            game.day_output
            game.actions_menu
        # elsif choice == 2
            # continue
        # elsif choice == 3
            # score_show
        elsif choice == 4
            system('clear')
            exit
        end
    end
end

def start_new_game
    Launchy.open("https://www.youtube.com/watch?v=iqtkk6bYEpk")
    start = StartMenu.new
    sleep(1)
    start.main_menu
end

start_new_game