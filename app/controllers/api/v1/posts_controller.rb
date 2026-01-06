module Api
  module V1
    class PostsController < BaseController
      skip_before_action :authenticate_api_user!, only: [:index, :show]
      before_action :set_post, only: [:show, :update, :destroy]
      before_action :authorize_user!, only: [:update, :destroy]

      # GET /api/v1/posts
      def index
        @posts = Post.includes(:user, :images_attachments).order(created_at: :desc)

        # Фильтрация по пользователю
        @posts = @posts.where(user_id: params[:user_id]) if params[:user_id].present?

        # Поиск
        if params[:query].present?
          query = "%#{params[:query]}%"
          @posts = @posts.where("title LIKE ? OR body LIKE ?", query, query)
        end

        # Пагинация
        page = params[:page].to_i > 0 ? params[:page].to_i : 1
        per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 20
        per_page = [per_page, 100].min

        @posts = @posts.limit(per_page).offset((page - 1) * per_page)

        render json: {
          posts: @posts.map { |post| post_json(post) },
          meta: {
            page: page,
            per_page: per_page,
            total: Post.count
          }
        }, status: :ok
      end

      # GET /api/v1/posts/:id
      def show
        render json: post_json(@post, include_comments: true), status: :ok
      end

      # POST /api/v1/posts
      def create
        @post = current_api_user.posts.build(post_params)

        # Обработка изображений из multipart/form-data
        if params[:images].present?
          @post.images.attach(params[:images])
        end

        if @post.save
          render json: post_json(@post), status: :created
        else
          render json: {
            error: 'Failed to create post',
            messages: @post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/posts/:id
      def update
        # Обработка новых изображений
        if params[:images].present?
          @post.images.attach(params[:images])
        end

        if @post.update(post_params)
          render json: post_json(@post), status: :ok
        else
          render json: {
            error: 'Failed to update post',
            messages: @post.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        @post.destroy!
        render json: { message: 'Post was successfully deleted' }, status: :ok
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        # Принимаем параметры поста. Изображения обрабатываем отдельно выше для гибкости
        params.require(:post).permit(:title, :body)
      rescue ActionController::ParameterMissing
        # Позволяем отправлять только файлы без обертки post: {} если нужно
        params.permit(:title, :body)
      end

      def authorize_user!
        unless @post.user == current_api_user
          render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
        end
      end

      def post_json(post, include_comments: false)
        json = {
          id: post.id,
          title: post.title,
          body: post.body,
          created_at: post.created_at,
          updated_at: post.updated_at,
          user: post.user ? { id: post.user.id, email: post.user.email } : nil,
          images: post.images.attached? ? post.images.map { |img|
            {
              id: img.id,
              url: Rails.application.routes.url_helpers.url_for(img),
              filename: img.filename.to_s,
              content_type: img.content_type
            }
          } : []
        }

        if include_comments
          json[:comments] = post.comments.includes(:user).map do |comment|
            {
              id: comment.id,
              body: comment.body,
              created_at: comment.created_at,
              user: comment.user ? { id: comment.user.id, email: comment.user.email } : nil
            }
          end
        end

        json
      end
    end
  end
end
