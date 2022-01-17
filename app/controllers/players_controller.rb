class PlayersController < ApplicationController

  def index
    @competition = Competition.find(params[:competition_id])
    @players = Player.all
    @game = Game.find(params[:game_id])
  end

  def new
    @game = Game.find(params[:game_id])
    @player = @game.players.new
  end

  def create
    @competition = Competition.find(params[:competition_id])
    @game = Game.find(params[:game_id])
    i = 0
    @competition_teams_array = Team.all.select { |team| team.competition_id == @competition.id }.map { |team| team.id }
    p "This is what we're trying to see #{@competition_teams_array}"
      24.times do # Replace hardcoded 24 with the number of teams for the competition (@competition.number_of_teams) - Maybe add a new column in competitions table to make this possible
        @player = @game.players.create(name: params["player"]["player#{i + 1}"], team_id: @competition_teams_array[i])
        i += 1
      end
    redirect_to competition_game_player_url(@competition.id, @game.id, @player.id)
  end

  def show
    @competition = Competition.find(params[:competition_id])
    @game = Game.find(params[:game_id])
    @players = Player.all.select { |player| player.game_id == @game.id }
    @teams = Team.all.select { |team| team.competition_id == @competition.id }
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end
  
end
