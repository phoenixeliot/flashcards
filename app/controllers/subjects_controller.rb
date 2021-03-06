class SubjectsController < ApplicationController
  before_action :verify_logged_in

  def index
    @subjects = Subject.all

    render :index
  end

  def show
    @subject = Subject.find(params[:id])
    @flashcards = @subject.flashcards

    respond_to do |format|
      format.html {render :show }
      format.csv { send_data @flashcards.to_csv }
    end
  end

  def new
    @subject = Subject.new

    render :new
  end

  def create
    @subject = Subject.new(subject_params)
    @subject.author_id = current_user.id

    if @subject.save
      flash[:notice] = "Success!"

      redirect_to user_subject_url(@subject)
    else
      flash[:errors] = @subject.errors.full_messages

      render :new
    end
  end

  def edit
    @subject = Subject.find(params[:id])

    render :edit
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update(subject_params)
      flash[:notice] = "Success!"

      redirect_to user_subject_url(@subject)
    else
      flash[:errors] = @subject.errors.full_messages

      render :new
    end
  end

  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy!

    redirect_to subjects_url
  end

  def contributors
    @subject_flashcards = Flashcard.where(subject_id: params[:id])
    @contributor_ids = @author_ids = @subject_flashcards
                        .select(:author_id).distinct.pluck(:author_id)
    @contributors = {}
    @contributor_ids.each do |id|
      score = @subject_flashcards.where(author_id: id).count
      @contributors[User.find(id).username] = score
    end

    @contributors = @contributors.sort_by {|_key, value| value}.reverse
  end

  private

  def subject_params
    params.require(:subject).permit(:name)
  end

end
